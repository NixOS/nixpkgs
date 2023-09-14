{ stdenv, lib, newScope, buildPackages, pkgs, makeSetupHook }:
lib.makeScope newScope (self: with self; {
  # build a buildPackages which has this freebsd scope parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd14.freebsd.buildPackages.freebsd will get you freebsd.packages14
  buildPackages = buildPackages // { freebsd = buildPackages.freebsd.overrideScope (_: _: { inherit hostVersion; }); };
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

  makeSource = callPackage ./source.nix {};
  compatIfNeeded = lib.optional (!stdenv.hostPlatform.isFreeBSD) compat;
  source = makeSource hostVersion;
  mkDerivation = callPackage ./make-derivation.nix {};
  compat = callPackage ./compat.nix { inherit pkgs; };
  bmake = callPackage ./bmake.nix {};
  makeMinimal = callPackage ./bmake-minimal.nix {};
  install = callPackage ./install.nix {};
  mtree = callPackage ./mtree.nix {};
  mknod = callPackage ./mknod.nix {};
  libnetbsd = callPackage ./libnetbsd.nix {};
  tsort = callPackage ./tsort.nix {};
  lorder = callPackage ./lorder.nix {};

  # Wrap NetBSD's install
  install-wrapper = builtins.readFile ./install-wrapper.sh;
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''
    ${buildPackages.netbsd.install}/bin/xinstall "''${args[@]}"
  '');
})
