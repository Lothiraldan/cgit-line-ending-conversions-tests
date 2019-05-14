

  $ export DATE="Mon 20 Aug 2018 20:19:19 BST"
  $ export GIT_AUTHOR_DATE="$DATE"
  $ export GIT_COMMITTER_DATE="$DATE"

  $ rm -Rf initial_client
  $ git init initial_client
  Initialized empty Git repository in $TESTTMP/initial_client/.git/
  $ cp $TESTDIR/crlf initial_client/
  $ cp $TESTDIR/lf initial_client/
  $ cd initial_client
  $ git add *lf
  $ git commit -m "Add files"
  [master (root-commit) 6341f27] Add files
   2 files changed, 6 insertions(+)
   create mode 100644 crlf
   create mode 100644 lf
  $ cd ..

Server
  $ rm -Rf server
  $ git init --bare server
  Initialized empty Git repository in $TESTTMP/server/

  $ cd initial_client
  $ git push --set-upstream ../server/ master
  To ../server/
   * [new branch]      master -> master
  Branch 'master' set up to track remote branch 'master' from '../server/'.
  $ cd ..

  $ cd server
  $ git log
  commit 6341f27446e365e238ba2170a10ddf78fe97ec97
  Author: Boris FELD <Foo Bar foo.bar@example.com>
  Date:   Mon Aug 20 20:19:19 2018 +0100
  
      Add files
  $ cd ..

Windows clone
  $ rm -Rf Windows
  $ git init Windows
  Initialized empty Git repository in $TESTTMP/Windows/.git/
  $ cd Windows
  $ git config core.autocrlf true
  $ git config core.eol crlf
  $ git config --list --show-origin
  file:/etc/gitconfig	filter.lfs.clean=git-lfs clean -- %f
  file:/etc/gitconfig	filter.lfs.smudge=git-lfs smudge -- %f
  file:/etc/gitconfig	filter.lfs.process=git-lfs filter-process
  file:/etc/gitconfig	filter.lfs.required=true
  file:.git/config	core.repositoryformatversion=0
  file:.git/config	core.filemode=true
  file:.git/config	core.bare=false
  file:.git/config	core.logallrefupdates=true
  file:.git/config	core.autocrlf=true
  file:.git/config	core.eol=crlf
  $ git pull ../server
  From ../server
   * branch            HEAD       -> FETCH_HEAD
  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ file lf
  lf: ASCII text, with CRLF line terminators
  $ cd ..

Linux clone
  $ rm -Rf Linux
  $ git init Linux
  Initialized empty Git repository in $TESTTMP/Linux/.git/
  $ cd Linux
  $ git config core.autocrlf input
  $ git config core.eol lf
  $ git config --list --show-origin
  file:/etc/gitconfig	filter.lfs.clean=git-lfs clean -- %f
  file:/etc/gitconfig	filter.lfs.smudge=git-lfs smudge -- %f
  file:/etc/gitconfig	filter.lfs.process=git-lfs filter-process
  file:/etc/gitconfig	filter.lfs.required=true
  file:.git/config	core.repositoryformatversion=0
  file:.git/config	core.filemode=true
  file:.git/config	core.bare=false
  file:.git/config	core.logallrefupdates=true
  file:.git/config	core.autocrlf=input
  file:.git/config	core.eol=lf
  $ git pull ../server
  From ../server
   * branch            HEAD       -> FETCH_HEAD
  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ file lf
  lf: ASCII text
  $ cd ..

Updating crlf on windows
  $ cd Windows

  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ cp $TESTDIR/updated_crlf crlf
  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   crlf
  
  no changes added to commit (use "git add" and/or "git commit -a")
  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ cat crlf
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)
  $ git add crlf
  $ git commit -m "Update CRLF" "--date=$DATE"
  [master 6c8ae77] Update CRLF
   Date: Mon Aug 20 20:19:19 2018 +0100
   1 file changed, 3 insertions(+), 1 deletion(-)

  $ git push -u ../server master
  To ../server
     6341f27..6c8ae77  master -> master
  Branch 'master' set up to track remote branch 'master' from '../server'.

  $ cd ..

Pull from Linux

  $ cd Linux/

  $ git pull ../server
  From ../server
   * branch            HEAD       -> FETCH_HEAD
  Updating 6341f27..6c8ae77
  Fast-forward
   crlf | 4 +++-
   1 file changed, 3 insertions(+), 1 deletion(-)

  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ cat crlf
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)

Update LF from Linux

  $ cp $TESTDIR/updated_lf lf
  $ git add lf
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	modified:   lf
  
  $ git commit -m "Update LF" --date="$DATE"
  [master 9087b92] Update LF
   Date: Mon Aug 20 20:19:19 2018 +0100
   1 file changed, 3 insertions(+), 1 deletion(-)

  $ git push -u ../server/ master
  To ../server/
     6c8ae77..9087b92  master -> master
  Branch 'master' set up to track remote branch 'master' from '../server/'.
  $ cd ..

Pull from Windows

  $ cd Windows/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 6c8ae77..9087b92
  Fast-forward
   lf | 4 +++-
   1 file changed, 3 insertions(+), 1 deletion(-)
  $ file lf
  lf: ASCII text, with CRLF line terminators
  $ cat lf
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5\r (esc)
  $ cd ..

Update CRLF from Linux

  $ cd Linux/
  $ cat crlf > crlf2
  $ cat crlf >> crlf2
  $ mv crlf2 crlf
  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ cat crlf
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)
  $ git add crlf
  $ git commit -m "Update crlf from Linux"
  [master 02db6b9] Update crlf from Linux
   1 file changed, 4 insertions(+)
  $ git push
  To ../server/
     9087b92..02db6b9  master -> master

  $ cd ..

Pull in Windows

  $ cd Windows/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 9087b92..02db6b9
  Fast-forward
   crlf | 4 ++++
   1 file changed, 4 insertions(+)
  $ file crlf
  crlf: ASCII text, with CRLF line terminators
  $ cat crlf
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)
  $ cd ..


Introduce new CRLF file on Linux

  $ cd Linux/
  $ cp $TESTDIR/updated_crlf new_crlf_from_linux
  $ file new_crlf_from_linux
  new_crlf_from_linux: ASCII text, with CRLF line terminators
  $ git add new_crlf_from_linux
  warning: CRLF will be replaced by LF in new_crlf_from_linux.
  The file will have its original line endings in your working directory.
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	new file:   new_crlf_from_linux
  
  $ git commit -m "Add new CRLF file" --date="$DATE"
  [master a980814] Add new CRLF file
   Date: Mon Aug 20 20:19:19 2018 +0100
   1 file changed, 5 insertions(+)
   create mode 100644 new_crlf_from_linux
  $ git status
  On branch master
  nothing to commit, working tree clean
  $ git diff
  $ git push
  To ../server/
     02db6b9..a980814  master -> master
  $ cd ..

Check on Windows

  $ cd Windows
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 02db6b9..a980814
  Fast-forward
   new_crlf_from_linux | 5 +++++
   1 file changed, 5 insertions(+)
   create mode 100644 new_crlf_from_linux
  $ file new_crlf_from_linux
  new_crlf_from_linux: ASCII text, with CRLF line terminators
  $ cat new_crlf_from_linux
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)

Add new CRLF file from Windows

  $ cp $TESTDIR/updated_crlf new_crlf_from_windows
  $ file new_crlf_from_windows
  new_crlf_from_windows: ASCII text, with CRLF line terminators
  $ git add new_crlf_from_windows
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	new file:   new_crlf_from_windows
  
  $ git commit -m "Add new CRLF file" --date="$DATE"
  [master 0bdb473] Add new CRLF file
   Date: Mon Aug 20 20:19:19 2018 +0100
   1 file changed, 5 insertions(+)
   create mode 100644 new_crlf_from_windows
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text, with CRLF line terminators
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text, with CRLF line terminators
  $ touch new_crlf_from_windows
  $ git status
  On branch master
  nothing to commit, working tree clean
  $ git diff
  $ git push
  To ../server
     a980814..0bdb473  master -> master
  $ cd ..

Check on Linux

  $ cd Linux/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating a980814..0bdb473
  Fast-forward
   new_crlf_from_windows | 5 +++++
   1 file changed, 5 insertions(+)
   create mode 100644 new_crlf_from_windows
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text
  $ file new_crlf_from_windows
  new_crlf_from_windows: ASCII text
  $ cat new_crlf_from_windows
  line1
  line2
  line3
  line4
  line5 (no-eol)
  $ cd ..

Check on a repo with no conversion

  $ cd initial_client
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 6341f27..0bdb473
  Fast-forward
   crlf                  | 8 +++++++-
   lf                    | 4 +++-
   new_crlf_from_linux   | 5 +++++
   new_crlf_from_windows | 5 +++++
   4 files changed, 20 insertions(+), 2 deletions(-)
   create mode 100644 new_crlf_from_linux
   create mode 100644 new_crlf_from_windows
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  new_crlf_from_linux:   ASCII text
  new_crlf_from_windows: ASCII text
  $ tail *
  ==> crlf <==
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5
  ==> lf <==
  line1
  line2
  line3
  line4
  line5
  
  ==> new_crlf_from_linux <==
  line1
  line2
  line3
  line4
  line5
  ==> new_crlf_from_windows <==
  line1
  line2
  line3
  line4
  line5 (no-eol)

  $ cd ..

Add CRLF to a LF file on Windows

  $ cd Windows/
  $ cp $TESTDIR/lf lf_plus_crlf_windows
  $ file lf_plus_crlf_windows
  lf_plus_crlf_windows: ASCII text
  $ git add lf_plus_crlf_windows
  warning: LF will be replaced by CRLF in lf_plus_crlf_windows.
  The file will have its original line endings in your working directory.
  $ git commit -m "Add lf_plus_crlf_windows"
  [master 7facbbf] Add lf_plus_crlf_windows
   1 file changed, 3 insertions(+)
   create mode 100644 lf_plus_crlf_windows
  $ cat crlf >> lf_plus_crlf_windows
  $ cat lf_plus_crlf_windows
  line1
  line2
  line3line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)
  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   lf_plus_crlf_windows
  
  no changes added to commit (use "git add" and/or "git commit -a")
  $ git add lf_plus_crlf_windows
  warning: LF will be replaced by CRLF in lf_plus_crlf_windows.
  The file will have its original line endings in your working directory.
  $ git commit -m "Update lf_plus_crlf_windows"
  [master e0b84b8] Update lf_plus_crlf_windows
   1 file changed, 9 insertions(+), 1 deletion(-)
  $ git push
  To ../server
     0bdb473..e0b84b8  master -> master

  $ git ls-files --stage
  100644 27016dc7b2cd2a7693784c1434d1a10fb962fd24 0	crlf
  100644 b3c5a95f929a50feb06c275ac567cdb1b441d1e2 0	lf
  100644 ac78b06021268ca398f1ec2e375d13b5d4c17434 0	lf_plus_crlf_windows
  100644 268185484434bda586922619ead46c68156f72a5 0	new_crlf_from_linux
  100644 268185484434bda586922619ead46c68156f72a5 0	new_crlf_from_windows

  $ cd ..

Add CRLF to a LF file on Linux

  $ cd Linux/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 0bdb473..e0b84b8
  Fast-forward
   lf_plus_crlf_windows | 11 +++++++++++
   1 file changed, 11 insertions(+)
   create mode 100644 lf_plus_crlf_windows
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text
  $ cat lf_plus_crlf_windows
  line1
  line2
  line3line1
  line2
  line3
  line4
  line5line1
  line2
  line3
  line4
  line5 (no-eol)

  $ cp lf lf_plus_crlf_linux
  $ file lf_plus_crlf_linux
  lf_plus_crlf_linux: ASCII text
  $ git add lf_plus_crlf_linux
  $ git commit -m "Add lf_plus_crlf_linux"
  [master 056b0e0] Add lf_plus_crlf_linux
   1 file changed, 5 insertions(+)
   create mode 100644 lf_plus_crlf_linux
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  lf_plus_crlf_linux:    ASCII text
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text
  $ cat lf_plus_crlf_linux
  line1
  line2
  line3
  line4
  line5
  $ cat crlf >> lf_plus_crlf_linux
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  lf_plus_crlf_linux:    ASCII text, with CRLF, LF line terminators
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text
  $ cat lf_plus_crlf_linux
  line1
  line2
  line3
  line4
  line5
  line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5line1\r (esc)
  line2\r (esc)
  line3\r (esc)
  line4\r (esc)
  line5 (no-eol)
  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   lf_plus_crlf_linux
  
  no changes added to commit (use "git add" and/or "git commit -a")
  $ git diff
  warning: CRLF will be replaced by LF in lf_plus_crlf_linux.
  The file will have its original line endings in your working directory.
  diff --git a/lf_plus_crlf_linux b/lf_plus_crlf_linux
  index b3c5a95..1f34efb 100644
  --- a/lf_plus_crlf_linux
  +++ b/lf_plus_crlf_linux
  @@ -3,3 +3,12 @@ line2
   line3
   line4
   line5
  +line1
  +line2
  +line3
  +line4
  +line5line1
  +line2
  +line3
  +line4
  +line5
  \ No newline at end of file
  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   lf_plus_crlf_linux
  
  no changes added to commit (use "git add" and/or "git commit -a")
  $ git add lf_plus_crlf_linux
  warning: CRLF will be replaced by LF in lf_plus_crlf_linux.
  The file will have its original line endings in your working directory.
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	modified:   lf_plus_crlf_linux
  
  $ git commit -m "Update lf_plus_crlf_linux"
  [master fb5aeb2] Update lf_plus_crlf_linux
   1 file changed, 9 insertions(+)
  $ git push
  To ../server/
     e0b84b8..fb5aeb2  master -> master
  $ git ls-files --stage
  100644 27016dc7b2cd2a7693784c1434d1a10fb962fd24 0	crlf
  100644 b3c5a95f929a50feb06c275ac567cdb1b441d1e2 0	lf
  100644 1f34efbd8cbfdd7ecca38653de13b7c1423b718d 0	lf_plus_crlf_linux
  100644 ac78b06021268ca398f1ec2e375d13b5d4c17434 0	lf_plus_crlf_windows
  100644 268185484434bda586922619ead46c68156f72a5 0	new_crlf_from_linux
  100644 268185484434bda586922619ead46c68156f72a5 0	new_crlf_from_windows

  $ cd ..

Check status and diff behavior

  $ cd Linux/

  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Already up to date.

  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  lf_plus_crlf_linux:    ASCII text, with CRLF, LF line terminators
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text

  $ touch crlf

  $ git status
  On branch master
  nothing to commit, working tree clean

  $ git diff

  $ cd ..

Check if renormalization would do something on Linux

  $ cd Linux/

  $ git add --renormalize .

  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	modified:   crlf
  

  $ cd ../

Check if renormalization would do something on Windows

  $ cd Windows/

  $ git add --renormalize .

  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	modified:   crlf
  
  $ git reset HEAD .

  $ cd ../

Try replacing line-ending on Windows

  $ cd Windows/

  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating e0b84b8..fb5aeb2
  Fast-forward
   lf_plus_crlf_linux | 14 ++++++++++++++
   1 file changed, 14 insertions(+)
   create mode 100644 lf_plus_crlf_linux

  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text, with CRLF line terminators
  lf_plus_crlf_linux:    ASCII text, with CRLF line terminators
  lf_plus_crlf_windows:  ASCII text, with CRLF, LF line terminators
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text, with CRLF line terminators

  $ dos2unix crlf
  dos2unix: converting file crlf to Unix format...

  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   crlf
  
  no changes added to commit (use "git add" and/or "git commit -a")

  $ git diff
  warning: LF will be replaced by CRLF in crlf.
  The file will have its original line endings in your working directory.
  diff --git a/crlf b/crlf
  index 27016dc..9d64892 100644
  --- a/crlf
  +++ b/crlf
  @@ -1,9 +1,9 @@
  -line1\r (esc)
  -line2\r (esc)
  -line3\r (esc)
  -line4\r (esc)
  -line5line1\r (esc)
  -line2\r (esc)
  -line3\r (esc)
  -line4\r (esc)
  +line1
  +line2
  +line3
  +line4
  +line5line1
  +line2
  +line3
  +line4
   line5
  \ No newline at end of file

  $ git add crlf
  warning: LF will be replaced by CRLF in crlf.
  The file will have its original line endings in your working directory.

  $ file *
  crlf:                  ASCII text
  lf:                    ASCII text, with CRLF line terminators
  lf_plus_crlf_linux:    ASCII text, with CRLF line terminators
  lf_plus_crlf_windows:  ASCII text, with CRLF, LF line terminators
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text, with CRLF line terminators

  $ git commit -m "Replace CRLF by LF in crlf file on Windows"
  [master 2dddb40] Replace CRLF by LF in crlf file on Windows
   1 file changed, 8 insertions(+), 8 deletions(-)

  $ git push
  To ../server
     fb5aeb2..2dddb40  master -> master

  $ git checkout -- .

  $ cd ../

Try replacing line-ending on Linux

  $ cd Linux/

  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating fb5aeb2..2dddb40
  Fast-forward
   crlf | 16 ++++++++--------
   1 file changed, 8 insertions(+), 8 deletions(-)

  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text
  lf_plus_crlf_linux:    ASCII text, with CRLF, LF line terminators
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text

  $ unix2dos lf
  unix2dos: converting file lf to DOS format...
  $ dos2unix new_crlf_from_linux
  dos2unix: converting file new_crlf_from_linux to Unix format...

  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text, with CRLF line terminators
  lf_plus_crlf_linux:    ASCII text, with CRLF, LF line terminators
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text
  new_crlf_from_windows: ASCII text

  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
  	modified:   lf
  	modified:   new_crlf_from_linux
  
  no changes added to commit (use "git add" and/or "git commit -a")

  $ git diff -w
  warning: CRLF will be replaced by LF in lf.
  The file will have its original line endings in your working directory.

  $ git add lf new_crlf_from_linux
  warning: CRLF will be replaced by LF in lf.
  The file will have its original line endings in your working directory.

  $ git commit -m "Replace line-endings on Linux"
  On branch master
  nothing to commit, working tree clean
  [1]

  $ git push
  Everything up-to-date

  $ git checkout -- .

  $ cd ../

Add new LF file from Windows

  $ cd Windows/

  $ cp $TESTDIR/updated_lf new_lf_from_windows
  $ file new_lf_from_windows
  new_lf_from_windows: ASCII text
  $ git add new_lf_from_windows
  warning: LF will be replaced by CRLF in new_lf_from_windows.
  The file will have its original line endings in your working directory.
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
  	new file:   new_lf_from_windows
  
  $ git commit -m "Add new LF file" --date="$DATE"
  [master 93dfda1] Add new LF file
   Date: Mon Aug 20 20:19:19 2018 +0100
   1 file changed, 5 insertions(+)
   create mode 100644 new_lf_from_windows
  $ file *
  crlf:                  ASCII text
  lf:                    ASCII text, with CRLF line terminators
  lf_plus_crlf_linux:    ASCII text, with CRLF line terminators
  lf_plus_crlf_windows:  ASCII text, with CRLF, LF line terminators
  new_crlf_from_linux:   ASCII text, with CRLF line terminators
  new_crlf_from_windows: ASCII text, with CRLF line terminators
  new_lf_from_windows:   ASCII text
  $ touch new_lf_from_windows
  $ git status
  On branch master
  nothing to commit, working tree clean
  $ git diff
  $ git push
  To ../server
     2dddb40..93dfda1  master -> master
  $ cd ..

Check on Linux

  $ cd Linux/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 2dddb40..93dfda1
  Fast-forward
   new_lf_from_windows | 5 +++++
   1 file changed, 5 insertions(+)
   create mode 100644 new_lf_from_windows
  $ file *
  crlf:                  ASCII text, with CRLF line terminators
  lf:                    ASCII text, with CRLF line terminators
  lf_plus_crlf_linux:    ASCII text, with CRLF, LF line terminators
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text
  new_crlf_from_windows: ASCII text
  new_lf_from_windows:   ASCII text
  $ file new_lf_from_windows
  new_lf_from_windows: ASCII text
  $ cat new_lf_from_windows
  line1
  line2
  line3
  line4
  line5
  $ cd ..


Check on a repo without conversion

  $ cd initial_client/
  $ git pull
  From ../server
   * branch            master     -> FETCH_HEAD
  Updating 0bdb473..93dfda1
  Fast-forward
   crlf                 | 16 ++++++++--------
   lf_plus_crlf_linux   | 14 ++++++++++++++
   lf_plus_crlf_windows | 11 +++++++++++
   new_lf_from_windows  |  5 +++++
   4 files changed, 38 insertions(+), 8 deletions(-)
   create mode 100644 lf_plus_crlf_linux
   create mode 100644 lf_plus_crlf_windows
   create mode 100644 new_lf_from_windows
  $ file *
  crlf:                  ASCII text
  lf:                    ASCII text
  lf_plus_crlf_linux:    ASCII text
  lf_plus_crlf_windows:  ASCII text
  new_crlf_from_linux:   ASCII text
  new_crlf_from_windows: ASCII text
  new_lf_from_windows:   ASCII text
  $ tail *
  ==> crlf <==
  line1
  line2
  line3
  line4
  line5line1
  line2
  line3
  line4
  line5
  ==> lf <==
  line1
  line2
  line3
  line4
  line5
  
  ==> lf_plus_crlf_linux <==
  line5
  line1
  line2
  line3
  line4
  line5line1
  line2
  line3
  line4
  line5
  ==> lf_plus_crlf_windows <==
  line2
  line3line1
  line2
  line3
  line4
  line5line1
  line2
  line3
  line4
  line5
  ==> new_crlf_from_linux <==
  line1
  line2
  line3
  line4
  line5
  ==> new_crlf_from_windows <==
  line1
  line2
  line3
  line4
  line5
  ==> new_lf_from_windows <==
  line1
  line2
  line3
  line4
  line5
