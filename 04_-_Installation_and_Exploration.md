# Day 4 - Installing software, Exploring the File System

## INTRO

installing, maintaining and removing software is bread and butter stuff.  Thankfully it's nice and easy to do in Linux, especially in Debian / Ubuntu. on a very basic level, the syntax is:

```text
(sudo) apt <verb> <argument>
```

Verbs are things like `install` `upgrade` `remove` and so on

for instance if we want to find a package named  `mc` we'd issue

```text
sudo apt search mc
```

or install it

```text
sudo apt install mc
```

or remove it

```text
sudo apt remove mc
```

Before installing anything, it's good practise to make sure apt is working on the latest information.  We can do this by issuing

```text
sudo apt update
```

The output of this command may tell us that there are packages that can be upgraded.  We can upgrade everything in one fell swoop by

```text
sudo apt upgrade
```

The course talks about installing `mc`.  I've used this before, but never found it as fast as `cd`-ing around teh system.  Instead, I've installed another tool; `tree` (`sudo apt install tree`).

`tree` gives us a tree-like view of the system. It's perhaps easier to explain it with an example. If I issue `tree` in this repo, I see:

```text
.
├── 00_-_Getting_Started_With_AWS.md
├── 01_-_Accessing_Your_server.md
├── 02_-_Basic_Navigation.md
├── 03_-_Sudo_-_and_Ownership.md
├── 03_-_Sudo_and_Ownership.md
├── 04_-_Installation_and_Exploration.md
├── code
│   └── aws.sh
├── figures
│   ├── 0_launch_instance.jpg
│   ├── 1_change_region.jpg
│   ├── 2_select_ubuntu.jpg
│   ├── 3_select_type.jpg
│   ├── 4_add_tags.jpg
│   ├── 5_security_wide_open.jpg
│   ├── 6_instance_launching.jpg
│   └── 7_get_system_info.jpg
└── README.md
```

It's possible to get something similar using `ls` but I find tree much easier to read.

e.g. `ls -1R`:

```text
README.md

./code:
aws.sh

./figures:
0_launch_instance.jpg  4_add_tags.jpg
1_change_region.jpg    5_security_wide_open.jpg
2_select_ubuntu.jpg    6_instance_launching.jpg
3_select_type.jpg      7_get_system_info.jpg
Linux_Upskill_Challenge ⬤ ls -1R
.:
code
figures
00_-_Getting_Started_With_AWS.md
01_-_Accessing_Your_server.md
02_-_Basic_Navigation.md
03_-_Sudo_-_and_Ownership.md
03_-_Sudo_and_Ownership.md
04_-_Installation_and_Exploration.md
README.md

./code:
aws.sh

./figures:
0_launch_instance.jpg
1_change_region.jpg
2_select_ubuntu.jpg
3_select_type.jpg
4_add_tags.jpg
5_security_wide_open.jpg
6_instance_launching.jpg
7_get_system_info.jpg
```
