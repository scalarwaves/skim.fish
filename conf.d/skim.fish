# skim.fish is only meant to be used in interactive mode. If not in interactive mode and not in CI, skip the config to speed up shell startup
if not status is-interactive && test "$CI" != true
    exit
end

# Because of scoping rules, to capture the shell variables exactly as they are, we must read
# them before even executing _skim_search_variables. We use psub to store the
# variables' info in temporary files and pass in the filenames as arguments.
# # This variable is global so that it can be referenced by skim_configure_bindings and in tests
set --global _skim_search_vars_command '_skim_search_variables (set --show | psub) (set --names | psub)'


# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
skim_configure_bindings

# Doesn't erase autoloaded _skim_* functions because they are not easily accessible once key bindings are erased
function _skim_uninstall --on-event skim_uninstall
    _skim_uninstall_bindings

    set --erase _skim_search_vars_command
    functions --erase _skim_uninstall _skim_migration_message _skim_uninstall_bindings skim_configure_bindings
    complete --erase skim_configure_bindings

    set_color cyan
    echo "skim.fish uninstalled."
    echo "You may need to manually remove skim_configure_bindings from your config.fish if you were using custom key bindings."
    set_color normal
end

# function _fzf_migration_message --on-event fzf_update
#     set_color FF8C00 # dark orange
#     printf '\n%s\n' 'If you last updated fzf.fish before 2021-06-11, you need to migrate your key bindings.'
#     printf '%s\n\n' 'Check out https://github.com/PatrickF1/fzf.fish/wiki/Migration-Guides#v7.'
#     set_color normal
# end
