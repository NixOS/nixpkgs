{ stdenv, lib, newScope, buildPackages, pkgsHostHost, makeSetupHook, ... }:
lib.makeScope newScope (self: with self; {
  inherit stdenv;
  compatIsNeeded = !self.stdenv.hostPlatform.isFreeBSD;

  # build a self which is parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd14.freebsd.buildFreebsd will get you freebsd.packages14
  buildFreebsd = buildPackages.freebsd.overrideScope (_: _: { inherit hostVersion; });
  packages13 = self.overrideScope (_: _: { hostVersion = "freebsd13"; });
  packages14 = self.overrideScope (_: _: { hostVersion = "freebsd14"; });

  hostVersion = ''${self.stdenv.hostPlatform.parsed.kernel.name}${builtins.toString (self.stdenv.hostPlatform.parsed.kernel.version or "")}'';
  hostArchBsd = {
    x86_64 = "amd64";
    aarch64 = "arm64";
    i486 = "i386";
    i586 = "i386";
    i686 = "i386";
  }.${self.stdenv.hostPlatform.parsed.cpu.name} or self.stdenv.hostPlatform.parsed.cpu.name;

  patchesRoot = ./patches/${hostVersion};

  freebsdSetupHook = makeSetupHook {
    name = "freebsd-setup-hook";
  } ./setup-hook.sh;

  makeSource = callPackage ./source.nix {};
  compatIfNeeded = lib.optional compatIsNeeded compat;
  source = makeSource hostVersion;
  filterSource = callPackage ./filter-src.nix {};
  mkDerivation = callPackage ./make-derivation.nix {};

  # for cross-compiling or bootstrapping
  compat = callPackage ./compat.nix { stdenv = pkgsHostHost.stdenv; };
  bmakeMinimal = callPackage ./bmake-minimal.nix {};
  libmd = callPackage ./libmd.nix {};  # used for both
  install-wrapper = builtins.readFile ./install-wrapper.sh;
  xinstallBootstrap = callPackage ./boot-install.nix {};
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''
    ${xinstallBootstrap}/bin/xinstall "''${args[@]}"
  '');

  # core c/c++ deps
  include = callPackage ./include.nix {};
  csu = callPackage ./csu.nix {};
  libc = callPackage ./libc.nix {};
  libcxx = callPackage ./libcxx.nix {};
  libcxxrt = callPackage ./libcxxrt.nix {};

  bmake = callPackage ./bmake.nix {};
  install = callPackage ./install.nix {};
  mtree = callPackage ./mtree.nix {};
  mknod = callPackage ./mknod.nix {};
  libnetbsd = callPackage ./libnetbsd.nix {};
  tsort = callPackage ./tsort.nix {};
  lorder = callPackage ./lorder.nix {};
  rpcgen = callPackage ./rpcgen.nix {};
  gencat = callPackage ./gencat.nix {};
  cp = callPackage ./cp.nix {};
  bin = callPackage ./bin.nix {};
  libkvm = callPackage ./libkvm.nix {};
  libdl = callPackage ./libdl.nix {};
  libelf = callPackage ./libelf.nix {};
  iconv = callPackage ./iconv.nix {};
  libcapsicum = callPackage ./libcapsicum.nix {};
  libcasper = callPackage ./libcasper.nix {};
  libnv = callPackage ./libnv.nix {};
  libutil = callPackage ./libutil.nix {};
  libjail = callPackage ./libjail.nix {};
  libxo = callPackage ./libxo.nix {};
  libncurses-tinfo = callPackage ./libncurses-tinfo.nix {};
  libedit = callPackage ./libedit.nix {};
  libsm = callPackage ./libsm.nix {};
})
