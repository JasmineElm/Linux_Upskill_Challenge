# Day 3 - `sudo` and Ownership

I kind of covered the sudo tasks on [day one](00_-_Getting_Started_With_AWS.md), but it's a good revision; screwing up permissions is easily done, and can be difficult to spot and unpick.  The output of `ls -l` could do with a little extra explanation:

```bash
-rw-r----- 1 root shadow 1172 Feb 17 10:10 shadow
```

+ The first block; `-` is the type (`d` for directory, `-` for file)
+ the second: `rw-r-----` gives the file permissions
+ The third block `1` is the number of  hard links
+ The fourth (`root`)  is the file owner
+ The fifth (`root`) is the group owner
+ the sixth (`1172`) is the size in bytes
+ the seventh (`Feb 17 10:10`) is the date it was last modified, and
+ the final column is the filename

when we try to read `/etc/shadow` as the `ubuntu`, the system will check the permissions, the ownership, and group ownership.  Let's take the ownership first: `root shadow` The file is owned by `root` and belongs to the group `shadow`.

Next, let's look at the permissions. Permissions have the format `rwxrwxrwx`  

+ `r` means it can be read
+ `w` means it can be written to / deleted
+ `x` means it can be executed
+ `-` means no permission is set

There are three sets of these permissions:

+ the first is the owner (e.g. `root`)
+ the second is the group (e.g. `shadow`)
+ the final group is what everyone else can do

Back to our example `rw-r-----`; we now know that

+ `root` can `read` and `write`, but not `execute` (`rw-`)
+ members of `shadow` can `read` but not `write` or `execute` (`r--`)
+ everyone else can do nothing (`---`)

we're not the root user, but might have the `shadow` group.  let's check with: `groups ubuntu`

_Output_

```text
ubuntu : ubuntu adm dialout cdrom floppy sudo audio dip video plugdev netdev lxd
```

No `shadow` there, so we shouldn't be able to

+ read the file, `more /etc/shadow`,
+ or edit it `vi /etc/shadow`,
+ or remove it `rm -f /etc/shadow`

To edit the file we can't use the `shadow` group; we'll need to impersonate `root`.  There's a couple of ways of doing this: we can `su - root` (or simply `su -`) and spawn a root session, or we can `sudo`.  `sudo` is a nicer, less risky way of elevating rights; you issue a sudo for the command you want; as soon as the command is finished your access returns to what it was before.  On the other hand, `su -` requires you to remember to exit the session once you've finished needing the access.  

If we were wanting to just view the file, we _could_ add the group to our `ubuntu` account: `usermod -a -G shadow ubuntu` __But this means we inherit the group permissions across the system.__ This will undoubtedly be far too much if we're simply wanting to read a file once. Under the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege#History) it's far better to use `sudo` to quickly elevate our rights _just long enough_ to complete the task.
