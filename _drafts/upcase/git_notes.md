# Mastering Git

## Managing History

### `git log`
* Gives basic metadata on recent commits
* `git log --oneline` summarizes log to a single line
* `--decorate` Blue => HEAD (current check out), green => current branch, red => remote origin
* `--graph --all`, complete view of history with branches that have diverged and not made it back to master
* `git config --global alias.sla 'log --oneline --decorate --graph --all'` alias quoted command to `git sla`
* `--pretty=format: '%h - %an [%ar] %s'` %h => commit hash, %an => author name, %ar => relative date of commit, %s => short summary
* `git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'` similar command with colors
* `get help log` for more options
* `git log -E -i --grep 'cach(eing)'` (expanded regex, case insensitive)
* `git log -S with_active_subscription`, searches for commit changes the # of times it's used
* `git log --oneline -- Gemfile`, history of 1 specific file
* `git blame Gemfile`, who made change to file (sha, Author, date, change)
* `git show <sha-id>`, shows complete commit information including diff

## Undoing
* Note: you'll typically want to do this only in your own branch

* `git commit --amend --no-edit` add to previous commit, `--no-edit` won't open the text editor
* `git reset <filename>` will remove <filename> from being staged, without filename it will unstage everything currently staged
* `git checkout .` checkout current working directory, will remove previously changed files (this is destructive if you haven't committed files)
* `git reset --soft HEAD^` => `git config --global alias.uncommit 'reset --soft HEAD^'` HEAD is current branch checked out, ^ is the parent, --soft es that we should reset the branch (to point at that parent commit), but otherwise leave the files in the working directory and the index untouched.
* `git status --short`

## Crafting History with Rebase
* https://thoughtbot.com/upcase/videos/git-crafting-history
* `git add --patch` git will present an interface to look at each set of changes, so you can make a choice for each one

Key	| Operation
--- | ---
h |	Display the list of available keys and their operation
y |	Stage the current hunk
n |	Skip this hunk
s |	Split the hunk
a |	Stage this and all remaining hunks
q |	Quit, skipping all remaining hunks
e |	Edit the hunk manually, allowing for line be line staging

* `git diff --cached` shows the staged changes
* `git diff origin/master..master` shows changes for a range of commits from origin/master to master
* `git cherry-pick origin/master..master` copy commits onto a different branch, creates new commits instead of modifying the existing commits

* `git help rebase`
* `git rebase master`
> As an example, let's assume we have a branch that when started was based off of
> master. We've made some changes on our branch and now have two new commits, but
> at the same time our colleagues have also made changes on the master branch.
> When performing the rebase, Git finds the commits unique to our branch and
> computes the diff off the changes they introduced, then moves to the target
> branch, master in this case, and one by one applies the diffs, creating new
> commits reusing the commit messages from our branch. Once done, it updates our
> branch to point at the newest of these commits created by reapplying the diffs.

* `git rebase -i master`, interactive rebase allows you to squash multiple commits into a single commit
  * p, pick = use commit
  * r, reword = use commit, but edit the commit message
  * e, edit = use commit, but stop for amending
  * s, squash = use commit, but meld into previous commit
  * f, fixup = like "squash", but discard this commit's log message
  * x, exec = run command using shell


## Git Object Model
* https://thoughtbot.com/upcase/videos/git-object-model
* `git init`, this creates a hidden directory that lives within your repository

* `.git/objects`
  * Stays empty until you stage files, since Git isn't just polling in the background
  * After adding to staging, it will create a blob or hash which represents each file.  This will be stored in a directory that shares the first 2 letters of the hash, then the file name will be the remaining characters.
    * Hashing: mathematical function takes input and outputs the unique hash based on the SHA-1 algorithm
      * Determinism: when given the same input, it will always return the same output
      * Defined Range: the hash will always be 40 characters
      * Uniformity: with minor changes to code (for example capitalizing letters), should change the output hash to avoid collisions

  * `git cat-file -p <file-first-eight>` (-p pretty)
  * `git cat-file -t <file-first-eight>` (-t type)
  * blob: represents a file contents (not name), saves in a hash combining sha and blob

  * Directories
  * `git cat-file -p <directory-first-eight>` => `100644 blob 3b18e512dba79e4c8300dd08aeb37f8e728b8dad	readme.md` tree structur

  * `git ls-tree master` list tree for given branch
  ```
    040000 tree 67b21f78a4548b2ba3eab318bb3628d039e851e6	app
    100644 blob 3b18e512dba79e4c8300dd08aeb37f8e728b8dad	readme.md
  ```

  *  `git ls-tree 67b21f78a4548b2ba3eab318bb3628d039e851e6` list tree for given sha

* Git Commit Object
  * `git cat-file -p <commit-first-eight>` =>
  ```
    git cat-file -p 3f42b87
    tree 0cae7dc167b255c0123c7c396fc48ce40fc35cfa
    parent e7fb2aba4c8bc518ddfd218773d020370e261365
    author Zac Baston <zbaston@gmail.com> 1490109331 -0400
    committer Zac Baston <zbaston@gmail.com> 1490109331 -0400

    add app dir and file
  ```
    * tree: pointer to a single tree (always a single tree), can point to any number of subtrees
    * parent: reference to previous commit
    * author: metadata
    * committer: metadata
    * message metadata

### `.git/refs`
* `cat .git/refs/heads/master` current commit
* `git cat-file -t <hash-number>` get type
* Virtually any operation performed in git, changes what a given ref points at.
* The branch points at a commit. The commit then points to the tree, parents, etc.
* `.git/tags` => point to an important point in time, i.e. releases/fixed point in time
* `.git/remotes` => also points to a commit
* `cat .git/HEAD` Points to local branches. The directory is called heads, as our local branches are the collection of things that HEAD can point at.HEAD is the ultimate ref, defining what we currently have checked out.  

### Object Model Operations
* `git checkout -b new-branch`, creates new ref
* `git checkout -b other-branch master`, creates new ref and points it at the master
* `git checkout master -- app/assets/javascripts/applications.js`, reference different branch, then walk itself to file and copy to current branch
* `git commit -m "Add new file"`
  * takes all staged objects and stores as needed
  * typically involves at least 1 new blob
  * new tree for current version of working directory
  * builds commit object that points to new tree
  * updates checked out branch to point at this new commit

* `git merge --ff-only feature`
  * creates no new objects, simply updates current branch to reference different commit

* `git merge feature`
  * Creates a new tree from the existing trees, then creates a new commit which points back at this tree

* `git rebase master`, replays work from features on upstream branch
  * diffs the feature commits, then adds them to upstream branch 1 by 1
  * it will create new commit objects carrying over the commit message, but the original feature branch commits are now orphaned as no refs point to them

* `git rebase --interactive master`
  * squashes commits down to a single commit referencing the same tree (so we know it preserves history)

  ## GitHub and Remotes
  * https://github.com/github/hub
  * `hub browse`, opens branch in browser
  * `hub compare`, opens compare url
  * `hub pull-request`, opens text editor to add title and description for pull-request
  * `hub ci-status`, text value if CI is successful

  * To create Canonical URL, press Y on github file page.  Further, you can shift-click and highlight lines and it will update the URL

  * open associated pull request from current feature branch

  ```shell
    #!/bin/sh
    #/ Usage: git pr [<branch>]
    #/ Open the pull request page for <branch>, or the current branch if not
    #/ specified. Lands on the new pull request page when no PR exists yet.
    #/ The branch must already be pushed

    # Based on script from @rtomayko
    set -e

    # usage message
    if [ "$1" == "--help" -o "$1" == '-h' ]; then
        grep ^#/ "$0" | cut -c4-
        exit
    fi

    remote_url=$(git config --get remote.origin.url)
    repo_with_owner=$(echo $remote_url | perl -pe's/(git@|https:\/\/)?github.com(:|\/)(\w+)\/(\w+)(.git)?/$3\/$4/')

    # figure out the branch
    branch=${1:-"$(git symbolic-ref HEAD | sed 's@refs/heads/@@')"}

    # check that the branch exists in the origin remote first
    if git rev-parse "refs/remotes/origin/$branch" 1>/dev/null 2>&1; then
        # escape forward slashes
        branch=${branch//\//\%2f}

        exec open "https://github.com/$repo_with_owner/pull/$branch"
    else
        echo "error: branch '$branch' does not exist on the origin remote." 1>&2
        echo "       try again after pushing the branch"
    fi
  ```

  * `fall = !for remote in $(git remote); do echo "Fetching $remote"; git fetch "$remote"; done`

## Thoughtbot Git Flow

1. Create branch on local env
2. Add files to staging
3. Commit changes
4. Push branch up to github
5. Create pull request
6. Code review
  * Tips:
    * Try to keep pull requests as small as possible.  This is convenient for others so they can review quickly.
    * Include more context for background in the pull request description.
    * Before/After screenshots if there is a UI change.  Next Level: make a GIF
    * If something is unfinished, use a task list to show work progress
7. Wait for PR comments
8. Revise and Push Updates
9. Rebase for FastForward Merge
10. Interactive Rebase
11. Close the Pull Request
12. Delete branch locally and on remote


## Learning More
* `git help <command>`
* https://help.github.com/
* http://gitready.com/
* https://github.com/pluralsight/git-internals-pdf
