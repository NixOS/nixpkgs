# Maintaining systemd

This document guides you through some of the important parts of maintaining
systemd.

## Preparing and Testing Changes

Changing systemd (most importantly updating!) is quite cumbersome:

- It is very close to the root of the dependency tree and thus causes rebuilds
  of a lot of packages. It always needs to target staging.
- ALL tests need to be rebuilt if systemd changes because systemd is a
  mandatory part of NixOS.

To alleviate this, we have a special procedure for preparing and testing
changes to systemd. It is quite different from maintaining other packages in
Nixpkgs. Please read this carefully if you want to open a PR for systemd.

1. In your fork of Nixpkgs, create a new branch from the merge base of the
   master branch and staging. Changes to systemd need to target staging and
   this helps to keep the number of rebuilds minimal.

```sh
git switch --create systemd-changes $(git merge-base upstream/master upstream/staging)
```

2. Change the systemd package. Test it by (1) building the systemd package and
   (2) building `systemd.nixosTests.simple-vm`. When this is successful, commit the
   changes.

3. Check out master again and add your new branch to a new worktree.

```sh
git switch master
git worktree add ../systemd-changes systemd-changes
```

4. Apply this patch to your master checkout of Nixpkgs so that all tests use
   the systemd package from the newly created worktree. This allows you to only
   rebuild the systemd package itself without having to build all the other
   packages that depend on systemd. Note that the path for `systemdTest` in
   this patch will depend on the name of your worktree.

```patch
diff --git i/nixos/modules/module-list.nix w/nixos/modules/module-list.nix
index c57b627e875c..89f026efd786 100644
--- i/nixos/modules/module-list.nix
+++ w/nixos/modules/module-list.nix
@@ -2040,4 +2040,5 @@
       ./image/repart.nix
     ];
   }
+  ({ pkgs, ... }: {systemd.package = pkgs.systemdTest;})
 ]
diff --git i/pkgs/top-level/all-packages.nix w/pkgs/top-level/all-packages.nix
index 0e2defb6566c..c60c1f201828 100644
--- i/pkgs/top-level/all-packages.nix
+++ w/pkgs/top-level/all-packages.nix
@@ -8538,6 +8538,10 @@ with pkgs;

   libsysprof-capture = callPackage ../development/tools/profiling/sysprof/capture.nix { };

+  systemdTest = callPackage ../../../systemd-changes/pkgs/os-specific/linux/systemd {
+    # break some cyclic dependencies
+    util-linux = util-linuxMinimal;
+  };
   systemd = callPackage ../os-specific/linux/systemd {
     # break some cyclic dependencies
     util-linux = util-linuxMinimal;
```

5. Build all the systemd NixOS tests

```sh
nix-build -A systemd.nixosTests
```

You are encouraged to use a tool like [brr](https://github.com/nikstur/brr) or
[nix-fast-build](https://github.com/Mic92/nix-fast-build) to speed up
evaluation and building all these tests.

In conclusion, there are three quality gates for changes to systemd:

1. The package needs to build on staging.
2. The test `systemd.nixosTests.simple-vm` needs to pass on staging.
3. All `systemd.nixosTests` must pass on master with the changed systemd from a separate worktree.
