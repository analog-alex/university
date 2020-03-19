## Introduction


_From la Wik_:

**Git** is a distributed version-control system for tracking changes in source code during software development. It is designed for coordinating work among programmers, but it can be used to track changes in any set of files.

**GitHub** is a global company that provides hosting for software development version control using Git.

A simple diagram follows: 

![stages](https://miro.medium.com/max/1930/1*tjrF1ff5UjVNclwwe_GREg.png)


## Usage

### Cloning

After a remote GitHub repository has been created it is necessary to clone it locally.

```
git clone <repo_location_url>
```

### Branches

```
git branch // list local branches
git branch <branch_name> // creates branch
git branch -d <branch_name> // delete branch
```

### Commits

As the programmer makes alterations, additions and removals to the files inside the repository his work should be recorded in discrete chunks called commits.

```
git add <file_name> // stage file
git add . // stage all files 
git commit // commit the changes

git log // see the changes
```

A good commit message is very useful when tracking changes and revising a repositories history. As such it is adsvisable to read some articles about good commit messages from the pros, such as [this](https://chris.beams.io/posts/git-commit/)

### Remote tracking

```
git push // update remote repo with local changes
git fetch // download remote history
git pull // update local repo with remote changes (git fetch + git merge)
```

### Merges

```
git merge <branch_name>
```

### Rebases

```
git rebase <branch_name>
git rebase -i <branch_name>
```

### Reset

```
git reset <commit_id> // reset the local repository, perserving changes
git reset --hard <commit_id> // reset the local repository, eliminating changes
```

## Extras

### Reset unstaged changes

```
git checkout -- .
```

### Amend commit

```
git commit --amend
git push -f
```

### Get difference between local repo and origin

```
git diff // lists differences between working and commited files
git diff --name-only // same, but the file names only 
git diff --name-only --cached // list the difference between staged and commited files
```

### Prune local branched that are not present on remote

```
git fetch -p && for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do git branch -D $branch; done
```
