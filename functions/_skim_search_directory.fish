function _skim_search_directory --description "Search the current directory. Replace the current token with the selected file paths."
    set fd_opts --color=always $skim_fd_opts
    if test (fd --version | string replace --regex --all '[^\d]' '') -ge 830
        # fd >= 8.3.0 prepends ./ to all paths when output is being piped
        # we don't need this so we hide it by passing --strip-cwd-prefix
        # Remove this logic March '22 iff fd docs document --strip-cwd-prefix
        set --prepend fd_opts --strip-cwd-prefix
    end

    set skim_arguments --multi --ansi $skim_dir_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set unescaped_exp_token (string unescape -- $expanded_token)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set --append fd_opts --base-directory=$unescaped_exp_token
        # use the directory name as skim's prompt to indicate the search is limited to that directory
        set --prepend skim_arguments --prompt="$unescaped_exp_token" --preview="_skim_preview_file $expanded_token{}"
        set file_paths_selected $unescaped_exp_token(fd $fd_opts 2>/dev/null | _skim_wrapper $skim_arguments)
    else
        set --prepend skim_arguments --query="$unescaped_exp_token" --preview='_skim_preview_file {}'
        set file_paths_selected (fd $fd_opts 2>/dev/null | _skim_wrapper $skim_arguments)
    end


    if test $status -eq 0
        # Fish will cd implicitly if a directory name ending in a slash is provided.
        # To help the user leverage this feature, we automatically append / to the selected path if
        # - only one path was selected,
        # - the user was in the middle of inputting the first token,
        # - the path is a directory
        # Then, the user only needs to hit Enter once more to cd into that directory.
        if test (count $file_paths_selected) = 1
            set commandline_tokens (commandline --tokenize)
            if test "$commandline_tokens" = "$token" -a -d "$file_paths_selected"
                set file_paths_selected $file_paths_selected/
            end
        end

        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
