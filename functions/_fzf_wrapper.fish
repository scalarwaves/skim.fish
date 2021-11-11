function _fzf_wrapper --description "Prepares some environment variables before executing fzf."
    # Make sure fzf uses fish to execute preview commands, some of which
    # are autoloaded fish functions so don't exist in other shells.
    # Use --local so that it doesn't clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # If SKIM_DEFAULT_OPTIONS is not set, then set some sane defaults.
    # See https://github.com/junegunn/fzf#environment-variables
    if not set --query SKIM_DEFAULT_OPTIONS
        # cycle allows jumping between the first and last results, making scrolling faster
        # layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
        # border shows where the fzf window begins and ends
        # height=90% leaves space to see the current command and some scrollback, maintaining context of work
        # preview-window=wrap wraps long lines in the preview window, making reading easier
        # marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
        set --export SKIM_DEFAULT_OPTIONS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
    end

    sk $argv
end
