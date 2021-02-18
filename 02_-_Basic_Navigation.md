# Day 2 - Basic Navigation

`ls` and `cd` are bread-and-butter to using linux.  

The `cd` examples are good, `cd -` is a _very_ useful command that isn't as well known as it should be.  When I first started using Linux, I found the file structure outside of `$HOME` confusing: `/bin` contained binaries, but `/etc`, `/var`?

`/etc` or "editable text configuration" is home to some really useful files. Our configuration for scheduled tasks (`crontab`), mapping file systems (`fstab`), log rotation (`logrotate.*`) and a [whole host of other files](https://www.linuxtopia.org/online_books/introduction_to_linux/linux_The_most_important_configuration_files.html) are stored here.  
`/var` contains _variable data_: our logs, mail, caches and so on.  Having a poke around here is a good first step if something is going wrong, but you don't know _what_, though you'd probably want to use a searching tool rather than manually `cd`-ing and `cat`-ing individual files. Although the syntax of files and logs can be daunting, it is a good point to bring up Linux's "[everything is a file](https://en.wikipedia.org/wiki/Everything_is_a_file)" paradigm.  We can read these files using tools like `cat`, `more`, but we can use tools like `grep` to search through them, `sed` and `awk` to change them, or `vi` to manually edit them.

Although the rest of the directories under root are important, they are not ones I'd really visit.  It is useful to understand what you can expect to [find](http://www.aboutlinux.info/2007/03/what-does-etc-stands-for-in-linuxunix.html) in them though.

`ls` is an interesting one. There are loads of useful switch combinations, and everyone has their preferred ones.  I'm a great fan of `ls -1AG` which `G`roups, shows `A`lmost all, and displays `1` file per line.

The course uses `ls -ltr`  this is useful, but the human readable file sizes switch `ls -hltr` makes it easier to understand what you're seeing.  Adding an `-A` (`ls -hAltr`) makes it even better; you can see 'hidden' - anything starting with a dot is hidden - files also.  

The advice around using `man` is good, but some manpages can be difficult to digest quickly.  Using [tldr](https://tldr.sh/) can be a quicker way to get the basics, failing that, [Stack Overflow](https://stackoverflow.com/questions/tagged/bash) usually has the answer.
