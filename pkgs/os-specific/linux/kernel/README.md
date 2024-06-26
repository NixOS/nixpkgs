# How to add a new (major) version of the Linux kernel to Nixpkgs:

1.  Copy the old Nix expression (e.g., `linux-2.6.21.nix`) to the new one (e.g., `linux-2.6.22.nix`) and update it.

2.  Add the new kernel to the `kernels` attribute set in [`linux-kernels.nix`](./linux-kernels.nix) (e.g., create an attribute `kernel_2_6_22`).

3.  Update the kernel configuration:

    1. While in the Nixpkgs repository, enter the development shell for that kernel:

       ```console
       $ nix-shell -A linuxKernel.kernels.linux_2_6_22
       ```

    2. Unpack the kernel:

       ```console
       [nix-shell]$ pushd $(mktemp -d)
       [nix-shell]$ unpackPhase
       ```

    3. For each supported platform (`i686`, `x86_64`, `uml`) do the following:

       1. Make a copy from the old config (e.g., `config-2.6.21-i686-smp`) to the new one (e.g., `config-2.6.22-i686-smp`).

       2. Copy the config file for this platform (e.g., `config-2.6.22-i686-smp`) to `.config` in the unpacked kernel source tree.

       3. Run `make oldconfig ARCH={i386,x86_64,um}` and answer all questions. (For the uml configuration, also add `SHELL=bash`.) Make sure to keep the configuration consistent between platforms (i.e., don’t enable some feature on `i686` and disable it on `x86_64`).

       4. If needed, you can also run `make menuconfig`:

          ```ShellSession
          $ nix-shell -p ncurses pkg-config
          $ make menuconfig ARCH=arch
          ```

       5. Copy `.config` over the new config file (e.g., `config-2.6.22-i686-smp`).

4.  Test building the kernel:

```ShellSession
nix-build -A linuxKernel.kernels.kernel_2_6_22
```

If it compiles, ship it! For extra credit, try booting NixOS with it.

5.  It may be that the new kernel requires updating the external kernel modules and kernel-dependent packages listed in the `linuxPackagesFor` function in `linux-kernels.nix` (such as the NVIDIA drivers, AUFS, etc.). If the updated packages aren’t backwards compatible with older kernels, you may need to keep the older versions around.
