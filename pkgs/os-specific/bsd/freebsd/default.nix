{ stdenv, crossLibcStdenv, lib, newScope, buildPackages, pkgsBuildBuild, pkgsHostHost, makeSetupHook, ... }:
let ee = { inherit crossLibcStdenv buildPackages pkgsBuildBuild; };
    buildPackages' = buildPackages;
in
lib.makeScope newScope (self: with self; {
  inherit stdenv ee;
  compatIsNeeded = !stdenv.hostPlatform.isFreeBSD;

  # build a self which is parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd14.freebsd.buildFreebsd will get you freebsd.packages14
  buildFreebsd = self.overrideScope (_: _: { stdenv = pkgsBuildBuild.stdenv; ee = { buildPackages = buildPackages'; }; compatIsNeeded = !buildPackages'.stdenv.buildPlatform.isFreeBSD; });
  packages13 = self.overrideScope (_: _: { hostVersion = "freebsd13"; });
  packages14 = self.overrideScope (_: _: { hostVersion = "freebsd14"; });

  hostVersion = ''${stdenv.hostPlatform.parsed.kernel.name}${builtins.toString (stdenv.hostPlatform.parsed.kernel.version or "")}'';
  hostArchBsd = {
    x86_64 = "amd64";
    aarch64 = "arm64";
    i486 = "i386";
    i586 = "i386";
    i686 = "i386";
  }.${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name;

  patchesRoot = ./patches/${hostVersion};

  freebsdSetupHook = makeSetupHook {
    name = "freebsd-setup-hook";
  } ./setup-hook.sh;

  makeSource = callPackage ./source.nix ee;
  compatIfNeeded = lib.optional compatIsNeeded compat;
  source = makeSource hostVersion;
  mkDerivation = callPackage ./make-derivation.nix ee;
  compat = callPackage ./compat.nix ee // { stdenv = pkgsHostHost.stdenv; };
  bmake = callPackage ./bmake.nix ee;
  makeMinimal = callPackage ./bmake-minimal.nix ee;
  install = callPackage ./install.nix ee;
  mtree = callPackage ./mtree.nix ee;
  mknod = callPackage ./mknod.nix ee;
  libnetbsd = callPackage ./libnetbsd.nix ee;
  tsort = callPackage ./tsort.nix ee;
  lorder = callPackage ./lorder.nix ee;
  rpcgen = callPackage ./rpcgen.nix ee;
  gencat = callPackage ./gencat.nix ee;
  libmd = callPackage ../../../development/libraries/libmd { };
  cp = callPackage ./cp.nix ee;

  include = callPackage ./include.nix ee;
  csu = callPackage ./csu.nix ee;
  libc = callPackage ./libc.nix ee;

  # Wrap NetBSD's install
  install-wrapper = builtins.readFile ./install-wrapper.sh;
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''
    ${buildPackages.netbsd.install}/bin/xinstall "''${args[@]}"
  '');
})
