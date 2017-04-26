# Intermediate Shell Commands

## Slice and Dice

cat

`head`
`tail`
  -n 5 (only 5 lines)

`grep`
  default case sensitive
  you can combine flags
  --ignore-case, -i
  -E supports any regex
  --invert-match, -v
  -r, recursively search nested directories

`tree`
  brew install tree

sed "Stream Editor"
  transforms text inline, case sensitive, does not actually change file
  's/originalText/newText'
  -E, supports any regex
  -i, make changes in place
  '.old', add '.old' to end of unchanged file, '' empty string will save to the same file name
  example: sed -i '.old' 's/Hello'


## Pipes, Input & Output

Print contents of file
`cat file.txt`
`echo 'Hello!'`
These send text to STDIN.  Shell listens for input to STDIN and prints it out,
but this can be redirected using `>` operator
`echo 'Hello!' > file.txt` #=> file.txt will be overwritten with the contents of the `echo` command.
If we want to append the data to the file, use `>>` operator.

What if we `cat` a file doesn't exist?
`cat not_here.txt
cat: not_here.txt: No such file or directory`
This appears to be directed to STDOUT, but actually it is sent to STDERROR.  This can
be redirected similar to above using `2>`. To append, similar syntax like `2>>`.

What about redirecting both STDOUT and STDERROR to file?
`cat hello.text not_here.txt &> combined.txt`


`sort` will sort each line alphabetically
We can pipe output of one command as input to another command.
`sort file.txt | grep H` #=> Sorts the files, then will return any line containing a capital H

Multiple pipes can be used in a chain:
`sort file.txt | grep H | sed 's/Hi/Hello from Zac'`

Pipe connects STDOUT from command on the left, to the STDIN of the command on the right.
Piped commands can also be redirected to other files in the standard manner.
STDERROR will not be redirected via pipes. To redirected STDOUT and STDERROR, wrap the
commands in parenthesis:
`(cat file.txt | grep H | sed 's/Hi/Hello from Zac') &> test.txt`


## Shell Scripting

File name `name.sh`
To run, `sh name.sh`.
Or add shebang to top of file `#!/bin/sh` then `chmod +x name.sh` to make it executable.
While there are many other shell types (zsh, etc), /bin/sh is extremely portable and the most common.

Shell settings:
`set -e`, script will stop and raise an error otherwise it will continue
`set -o pipefail`, without pipefail will fail out if any part of a pipeline fails

Actual script:

```shell
#!/bin/sh

set -e
set-o pipefail

# $# is a variable that determines the number of args passed in
if [ $# -eq 0 ]; then
  echo "Please provide the name of the services directory."
  exit 64
fi

print_services() {
  # if exit code from grep is 0, then it will go inside the loop
  # -q makes it quiet
  # && and and,
  # || or or, run only if item on left fails
  # ; always runs second method
  # first argument is $1, second $2, etc
  if grep -q port "$1" && grep -q name "$1"; then
    # stores as variable. $() syntax is called process substitution. This will capture STDOUT of method and store as name
    name=$(grep name "$1" | sed 's/name //')
    port=$(grep port "$1" | sed 's/port //')

    # square notation here will check if true/false
    # -lt numerical comparison (less than), -gt greater than
    # -f is a file
    if ["$port" -lt 5000]; then
      "Port is under 5000"
    fi
    echo "In $1, we're running $name on $port."
  else
    echo "$1 does not have a name or a port."
  fi
}

#for loop which just prints out all files matching this glob pattern
for file in "$1"/*.service; do
  print_services "$file"
done

```

## Making Your Life Easier

### Aliases
`-iv` flag for cp, rm, mv stands for `interactive` and verbose.  Interactive means if we are doing something destructive, it will ask to confirm.  Verbose will provide a more descriptive message.

Global alias (`-g` flag) allows you to use pipe, whereas normal ones don't. Example `alias -g G="| grep "`
