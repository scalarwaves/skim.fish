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

# Add some messages to README
set --local readme (mktemp)
set --local preface '# skim.fish

This is a fork of PatrickF1\'s [fzf.fish](https://github.com/PatrickF1/fzf.fish).
Instead of fzf, it works with [skim](https://github.com/lotabout/skim), a clone of fzf written in Rust.

## Installation

```fish
fisher install mnacamura/skim.fish
```

**Original README for fzf.fish:**

---
'
set --local preface_nlines (echo $preface | command wc --lines)
echo $preface > $readme
if command grep -q skim README.md
    command cat README.md \
    | command awk "NR > "$preface_nlines" { print }" \
    >> $readme
else
    command cat README.md >> $readme
end
cp -f $readme README.md
rm -f $readme
