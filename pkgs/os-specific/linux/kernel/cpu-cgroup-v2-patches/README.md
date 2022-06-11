Patches for CPU Controller on Control Group v2
===============================================

See Tejun Heo's [explanation][1] for why these patches are currently
out-of-tree.

Generating the patches
-----------------------

In a linux checkout, with remote tc-cgroup pointing to
git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git, your
nixpkgs checkout in the same directory as your linux checkout (or
modify the command accordingly), and setting `ver` to the appropriate
version:

```shell
$ ver=4.7
$ git log --reverse --patch v$ver..remotes/tc-cgroup/cgroup-v2-cpu-v$ver > ../nixpkgs/pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/$ver.patch
```

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/tree/Documentation/cgroup-v2-cpu.txt?h=cgroup-v2-cpu
