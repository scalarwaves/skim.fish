#!/usr/bin/env fish
#
# Convert fzf.fish to skim.fish

# Rename FZF_DEFAULT_OPTS to SKIM_DEFAULT_OPTIONS
command sed -i conf.d/fzf.fish -e 's|FZF_DEFAULT_OPTS|SKIM_DEFAULT_OPTIONS|g'

# Replace command executions
for path in functions/*.fish
    command sed -i $path \
        -e 's#| fzf#| sk#g' \
        -e 's#fzf --#sk --#'
end
