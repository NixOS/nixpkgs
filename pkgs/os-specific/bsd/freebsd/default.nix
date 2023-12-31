{ stdenv, lib, newScope, buildPackages, pkgsHostHost, makeSetupHook, substituteAll, runtimeShell, ... }:
lib.makeScope newScope (self: with self; { inherit stdenv;
  #stdenv = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
  compatIsNeeded = !self.stdenv.hostPlatform.isFreeBSD;

  # build a self which is parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd14.freebsd.buildFreebsd will get you freebsd.packages14
  buildFreebsd = buildPackages.freebsd.overrideScope (_: _: { inherit hostVersion; });
  packages13 = self.overrideScope (_: _: { hostVersion = "freebsd13"; });
  packages14 = self.overrideScope (_: _: { hostVersion = "freebsd14"; });
  packages15 = self.overrideScope (_: _: { hostVersion = "freebsd15"; });

  hostVersion = if self.stdenv.hostPlatform.isFreeBSD
    then ''${self.stdenv.hostPlatform.parsed.kernel.name}${builtins.toString (self.stdenv.hostPlatform.parsed.kernel.version or "")}''
    else throw "The freebsd packages must be parameterized by a specific FreeBSD version when not building for FreeBSD. Do you want freebsd.packages14 or perhaps pkgsCross.x86_64-freebsd14.freebsd?";
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
  xargs-j = substituteAll {
    name = "xargs-j";
    shell = runtimeShell;
    src = ../xargs-j.sh;
    dir = "bin";
    isExecutable = true;
  };

  # core c/c++ deps
  include = callPackage ./include.nix {};
  csu = callPackage ./csu.nix {};
  libc = callPackage ./libc.nix {};
  libcxx = callPackage ./libcxx.nix {};
  libcxxrt = callPackage ./libcxxrt.nix {};

  # libs and bins
  bmake = callPackage ./bmake.nix {};
  install = callPackage ./install.nix {};
  mtree = callPackage ./mtree.nix {};
  mknod = callPackage ./mknod.nix {};
  libnetbsd = callPackage ./libnetbsd.nix {};
  tsort = callPackage ./tsort.nix {};
  lorder = callPackage ./lorder.nix {};
  rpcgen = callPackage ./rpcgen.nix {};
  getent = callPackage ./getent.nix {};
  gencat = callPackage ./gencat.nix {};
  cp = callPackage ./cp.nix {};
  bin = callPackage ./bin.nix {};
  less = callPackage ./less.nix {};
  libkvm = callPackage ./libkvm.nix {};
  libdl = callPackage ./libdl.nix {};
  libelf = callPackage ./libelf.nix {};
  iconv = callPackage ./iconv.nix {};
  libcapsicum = callPackage ./libcapsicum.nix {};
  libcasper = callPackage ./libcasper.nix {};
  libcrypt = callPackage ./libcrypt.nix {};
  libnv = callPackage ./libnv.nix {};
  libutil = callPackage ./libutil.nix {};
  libjail = callPackage ./libjail.nix {};
  libxo = callPackage ./libxo.nix {};
  libncurses-tinfo = callPackage ./libncurses-tinfo.nix {};
  libedit = callPackage ./libedit.nix {};
  libsm = callPackage ./libsm.nix {};
  libdevstat = callPackage ./libdevstat.nix {};
  libmemstat = callPackage ./libmemstat.nix {};
  libprocstat = callPackage ./libprocstat.nix {};
  libexecinfo = callPackage ./libexecinfo.nix {};
  localedef = callPackage ./localedef.nix {};
  config = callPackage ./config.nix {};
  libsbuf = callPackage ./libsbuf.nix {};
  file2c = callPackage ./file2c.nix {};
  bintrans = callPackage ./bintrans.nix {};
  vtfontcvt = callPackage ./vtfontcvt.nix {};
  btxld = callPackage ./btxld.nix {};
  mkimg = callPackage ./mkimg.nix {};
  makefs = callPackage ./makefs.nix {};
  librt = callPackage ./librt.nix {};
  init = callPackage ./init.nix {};
  rc = callPackage ./rc.nix {};
  mount = callPackage ./mount.nix {};
  fsck = callPackage ./fsck.nix {};
  nscd = callPackage ./nscd.nix {};
  sysctl = callPackage ./sysctl.nix {};
  protect = callPackage ./protect.nix {};
  id = callPackage ./id.nix {};
  stat = callPackage ./stat.nix {};
  rcorder = callPackage ./rcorder.nix {};
  getty = callPackage ./getty.nix {};
  login = callPackage ./login.nix {};
  libpam = callPackage ./libpam.nix {};
  tacplus = callPackage ./tacplus.nix {};
  libradius = callPackage ./libradius.nix {};
  libtacplus = callPackage ./libtacplus.nix {};
  libypclnt = callPackage ./libypclnt.nix {};
  libssh = callPackage ./libssh.nix {};
  libbsm = callPackage ./libbsm.nix {};
  cap_mkdb = callPackage ./cap_mkdb.nix {};
  pwd_mkdb = callPackage ./pwd_mkdb.nix {};
  truss = callPackage ./truss.nix {};
  libsysdecode = callPackage ./libsysdecode.nix {};

  # kernel
  sys = callPackage ./sys.nix {};

  # bootloader
  stand = callPackage ./stand.nix {};
  stand-efi = callPackage ./stand-efi.nix {};
})
