(local api vim.api)


(fn action [kwargs]
  (local {: jumper : input} (or kwargs {}))
  (local mode (vim.fn.mode true))

  ; We are back in Normal mode when this call is executed, so _we_
  ; should tell Leap whether it is OK to autojump. Visual and
  ; Operator-pending mode are both problematic, because we could only
  ; re-trigger them inside the leap() call, with a custom action, and
  ; that would prevent users from customizing the jumper.
  ; If `input` is given, all bets are off - before moving on to a
  ; labeled target, we would have to undo whatever action was taken
  ; (practically impossible) -, so in that case also disable autojump
  ; unconditionally.
  (fn default-jumper []
    (let [util (require "leap.util")
          leap (. (require "leap") :leap)]
      (leap {:opts (and (or input (not= mode "n")) {:safe_labels ""})
             :target_windows (util.get_focusable_windows)})))

  (local jumper (or jumper default-jumper))
  ; `jumper` can mess with these.
  (local state {: mode :count vim.v.count :register vim.v.register})

  (local src-win (vim.fn.win_getid))
  (local saved-view (vim.fn.winsaveview))
  ; Set an extmark as an anchor, so that we can execute remote delete
  ; commands in the backward direction, and move together with the text.
  (local anch-ns (api.nvim_create_namespace ""))
  (local anch-id (api.nvim_buf_set_extmark
                   0 anch-ns (- saved-view.lnum 1) saved-view.col {}))

  (fn restore []
    (when (not= (vim.fn.win_getid) src-win)
      (api.nvim_set_current_win src-win))
    (vim.fn.winrestview saved-view)
    (local anch-pos (api.nvim_buf_get_extmark_by_id 0 anch-ns anch-id {}))
    (api.nvim_win_set_cursor 0 [(+ (. anch-pos 1) 1) (. anch-pos 2)])
    (api.nvim_buf_clear_namespace 0 anch-ns 0 -1))

  (fn cancels? [key]
    (local mode (vim.fn.mode true))
    (or (= key (vim.keycode "<esc>"))
        (= key (vim.keycode "<c-c>"))
        (and (or (= mode "v") (= mode "V") (= mode ""))
             (= key mode))))

  (fn restore-on-finish []
    (var op-canceled? false)
    (local ns-id (vim.on_key
                   (fn [key typed]
                     (when (cancels? key)
                       (set op-canceled? true)))))
    ; Apparently, schedule wrap is necessary for Leap to work as the
    ; selector itself inside the remote action.
    (local callback (vim.schedule_wrap
                      (fn []
                        (restore)
                        (vim.on_key nil ns-id)  ; remove listener
                        (when (not op-canceled?)
                          (api.nvim_exec_autocmds :User
                            {:pattern "RemoteOperationDone"
                             :data state})))))
    (api.nvim_create_autocmd :ModeChanged
      {:pattern "*:*"
       :once true
       :callback (fn []
                   (local mode (vim.fn.mode true))
                   (if (and (mode:match "o") (= vim.v.operator "c"))
                        (api.nvim_create_autocmd :ModeChanged
                          {:pattern "i:n" :once true : callback})
                        (api.nvim_create_autocmd :ModeChanged
                          {:pattern "*:n" :once true : callback})))}))

  (fn feed [seq]
    (when seq (api.nvim_feedkeys seq "n" false))
    ; Remap keys, custom motions and text objects should work too.
    (when input (api.nvim_feedkeys input "" false)))

  ; Return to Normal mode.
  (if (state.mode:match "no")
      (do (api.nvim_feedkeys (vim.keycode "<C-\\><C-N>") "nx" false)
          ; Either schedule the rest, or put this after the jump.
          (api.nvim_feedkeys (vim.keycode "<esc>") "n" false))

      (state.mode:match "[vV]")
      (api.nvim_feedkeys state.mode "n" false))

  ; Execute "spooky" action: jump - operate - restore.
  (vim.schedule
    (fn []
      (jumper)
      ; Add target postion to jumplist.
      (vim.cmd "norm! m`")
      (if
        ; From Operator-pending: re-trigger the operation.
        (state.mode:match "no")
        (let [count (if (> state.count 0) state.count "")
              reg (.. "\"" state.register)
              force (state.mode:sub 3)]
          (feed (.. count reg vim.v.operator force)))

        ; From Visual: start the corresponding Visual mode again.
        (state.mode:match "[vV]")
        (feed state.mode)

        ; From Normal: just feed the (potential) prepared input.
        (feed))
      ; Set autocommand to restore state.
      (restore-on-finish))))


{: action}
