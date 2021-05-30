#!/usr/bin/env fish

function main \
    --description "Convert fzf.fish to skim.fish"

    rename_FZF_DEFAULT_OPTS_to_SKIM_DEFAULT_OPTIONS
    replace_command_executions
    add_some_explanation_for_this_fork
end

set -gx PROJECT_ROOT (git rev-parse --show-toplevel 2>/dev/null)

function rename_FZF_DEFAULT_OPTS_to_SKIM_DEFAULT_OPTIONS
    for path in $PROJECT_ROOT/conf.d/fzf.fish
        sed -i $path \
            -e 's|FZF_DEFAULT_OPTS|SKIM_DEFAULT_OPTIONS|g'
    end
end

function replace_command_executions
    for path in $PROJECT_ROOT/functions/*.fish
        sed -i $path \
            -e 's#| fzf#| sk#g' \
            -e 's#fzf --#sk --#g'
    end
end

set -l modified_readme (mktemp)

function teardown --on-process-exit $fish_pid --inherit modified_readme
    rm -f $modified_readme
end

function add_some_explanation_for_this_fork --inherit modified_readme
    set -l readme $PROJECT_ROOT/README.md
    set -l preface $PROJECT_ROOT/tools/preface.md
    set -l preface_end 'Original README for fzf.fish:'
    cat $preface >$modified_readme
    if grep -q $preface_end $readme
        set -l n (math 2 + (grep -En $preface_end $readme | cut -d: -f1))
        cat $readme | awk "NR > "$n" { print }" >>$modified_readme
    else
        cat $readme >>$modified_readme
    end
    cp -f $modified_readme $readme
end

main
