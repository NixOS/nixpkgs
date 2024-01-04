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
  csu = callPackage ./csu.nix {};
  include = callPackage ./include.nix {};
  libc = callPackage ./libc.nix {};
  libcxx = callPackage ./libcxx.nix {};
  libcxxrt = callPackage ./libcxxrt.nix {};

  # libs and bins
  bin = callPackage ./bin.nix {};
  bintrans = callPackage ./bintrans.nix {};
  bmake = callPackage ./bmake.nix {};
  btxld = callPackage ./btxld.nix {};
  cap_mkdb = callPackage ./cap_mkdb.nix {};
  config = callPackage ./config.nix {};
  cp = callPackage ./cp.nix {};
  file2c = callPackage ./file2c.nix {};
  fsck = callPackage ./fsck.nix {};
  gencat = callPackage ./gencat.nix {};
  getent = callPackage ./getent.nix {};
  getty = callPackage ./getty.nix {};
  iconv = callPackage ./iconv.nix {};
  id = callPackage ./id.nix {};
  ifconfig = callPackage ./ifconfig.nix {};
  init = callPackage ./init.nix {};
  install = callPackage ./install.nix {};
  less = callPackage ./less.nix {};
  lib80211 = callPackage ./lib80211.nix {};
  libbsdxml = callPackage ./libbsdxml.nix {};
  libbsm = callPackage ./libbsm.nix {};
  libcapsicum = callPackage ./libcapsicum.nix {};
  libcasper = callPackage ./libcasper.nix {};
  libcrypt = callPackage ./libcrypt.nix {};
  libdevstat = callPackage ./libdevstat.nix {};
  libdl = callPackage ./libdl.nix {};
  libedit = callPackage ./libedit.nix {};
  libelf = callPackage ./libelf.nix {};
  libexecinfo = callPackage ./libexecinfo.nix {};
  libifconfig = callPackage ./libifconfig.nix {};
  libjail = callPackage ./libjail.nix {};
  libkvm = callPackage ./libkvm.nix {};
  libmemstat = callPackage ./libmemstat.nix {};
  libncurses-tinfo = callPackage ./libncurses-tinfo.nix {};
  libnetbsd = callPackage ./libnetbsd.nix {};
  libnv = callPackage ./libnv.nix {};
  libpam = callPackage ./libpam.nix {};
  libprocstat = callPackage ./libprocstat.nix {};
  libradius = callPackage ./libradius.nix {};
  librt = callPackage ./librt.nix {};
  libsbuf = callPackage ./libsbuf.nix {};
  libsm = callPackage ./libsm.nix {};
  libssh = callPackage ./libssh.nix {};
  libsysdecode = callPackage ./libsysdecode.nix {};
  libtacplus = callPackage ./libtacplus.nix {};
  libutil = callPackage ./libutil.nix {};
  libxo = callPackage ./libxo.nix {};
  libypclnt = callPackage ./libypclnt.nix {};
  locale = callPackage ./locale.nix {};
  localedef = callPackage ./localedef.nix {};
  locales = callPackage ./locales.nix {};
  login = callPackage ./login.nix {};
  lorder = callPackage ./lorder.nix {};
  makefs = callPackage ./makefs.nix {};
  mkimg = callPackage ./mkimg.nix {};
  mknod = callPackage ./mknod.nix {};
  mount = callPackage ./mount.nix {};
  mtree = callPackage ./mtree.nix {};
  nscd = callPackage ./nscd.nix {};
  protect = callPackage ./protect.nix {};
  pwd_mkdb = callPackage ./pwd_mkdb.nix {};
  rc = callPackage ./rc.nix {};
  rcorder = callPackage ./rcorder.nix {};
  reboot = callPackage ./reboot.nix {};
  rpcgen = callPackage ./rpcgen.nix {};
  shutdown = callPackage ./shutdown.nix {};
  stat = callPackage ./stat.nix {};
  sysctl = callPackage ./sysctl.nix {};
  syslogd = callPackage ./syslogd.nix {};
  tacplus = callPackage ./tacplus.nix {};
  truss = callPackage ./truss.nix {};
  tsort = callPackage ./tsort.nix {};
  vtfontcvt = callPackage ./vtfontcvt.nix {};

  # kernel
  sys = callPackage ./sys.nix {};

  # bootloader
  stand = callPackage ./stand.nix {};
  stand-efi = callPackage ./stand-efi.nix {};
})
