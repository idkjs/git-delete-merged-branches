#!/usr/bin/env fish
set script_dir (realpath (dirname (status --current-filename)))

bass source $script_dir/git-delete-merged-branches
