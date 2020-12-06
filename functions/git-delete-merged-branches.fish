#!/usr/bin/env fish

function branches_to_die
    set branches_to_die (git branch --no-color --merged origin/master | grep -v '\smaster$')
    echo "Local branches to be deleted:"
    echo $branches_to_die
end

function kill_branches
    echo $branches_to_die | xargs -n 1 git branch -D
end

function remote_branches_to_die

    set semote_branches_to_die (git branch --no-color --remote --merged origin/master | grep -v '\smaster$' | grep -v '\/master$' | grep -v "origin\/HEAD" | grep -v "origin\/master")
    echo "Remote branches to be deleted:"
    echo $remote_branches_to_die
end

funcion kill_remote_branches
# Remove remote branches
for remote in $remote_branches_to_die

    # branches=`echo "$remote_branches" | grep "$remote/" | sed 's/\(.*\)\/\(.*\)/:\2 /g' | tr -d '\n'`
    git branch -rD "$remote"

end

function confirm
    while true
        read --local --prompt=confirm_prompt confirm_
        switch $confirm_
            case '' N n
                return 1
            case Y y
                return 0
        end
    end
end

function confirm_prompt
    echo 'Enter Y to confirm" [y/N] '
end

function git-delete-merged-branches
    if $confirm
        kill_branches
        kill_remote_branches
        echo ""
        echo "Pruning all remotes"
        git remote | xargs -n 1 git remote prune
    else
        return 0
    end
end
