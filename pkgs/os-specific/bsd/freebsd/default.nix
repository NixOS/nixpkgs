{ stdenv, crossLibcStdenv, lib, newScope, buildPackages, pkgsBuildBuild, pkgsHostHost, makeSetupHook, ... }:
lib.makeScope newScope (self: with self; {
  inherit stdenv;
  compatIsNeeded = !self.stdenv.hostPlatform.isFreeBSD;

  # build a self which is parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd14.freebsd.buildFreebsd will get you freebsd.packages14
  buildFreebsd = buildPackages.freebsd.overrideScope (_: _: { inherit hostVersion; });
  #buildFreebsd = self.overrideScope (_: _: { stdenv = buildPackages.stdenv; inherit hostVersion hostArchBsd; });
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
  mkDerivation = callPackage ./make-derivation.nix {};
  compat = callPackage ./compat.nix { stdenv = pkgsHostHost.stdenv; };
  bmake = callPackage ./bmake.nix {};
  makeMinimal = callPackage ./bmake-minimal.nix {};
  install = callPackage ./install.nix {};
  mtree = callPackage ./mtree.nix {};
  mknod = callPackage ./mknod.nix {};
  libnetbsd = callPackage ./libnetbsd.nix {};
  tsort = callPackage ./tsort.nix {};
  lorder = callPackage ./lorder.nix {};
  rpcgen = callPackage ./rpcgen.nix {};
  gencat = callPackage ./gencat.nix {};
  libmd = callPackage ../../../development/libraries/libmd {};
  cp = callPackage ./cp.nix {};

  include = callPackage ./include.nix {};
  csu = callPackage ./csu.nix {};
  libc = callPackage ./libc.nix {};
  libcxx = callPackage ./libcxx.nix {};
  libcxxrt = callPackage ./libcxxrt.nix {};

  # Wrap NetBSD's install
  install-wrapper = builtins.readFile ./install-wrapper.sh;
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''
    ${buildPackages.netbsd.install}/bin/xinstall "''${args[@]}"
  '');
})
