/*
  A small release file, with few packages to be built.  The aim is to reduce
  the load on Hydra when testing the `stdenv-updates' branch.
*/

{
  nixpkgs ? {
    outPath = (import ../../lib).cleanSource ../..;
    revCount = 1234;
    shortRev = "abcdef";
  },
  supportedSystems ? [
    "x86_64-linux"
    "x86_64-darwin"
  ],
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? {
    config = {
      allowAliases = false;
      allowUnfree = false;
      inHydra = true;
    };

    __allowFileset = false;
  },
}:

let
  release-lib = import ./release-lib.nix {
    inherit supportedSystems nixpkgsArgs;
  };

  inherit (release-lib)
    all
    linux
    darwin
    mapTestOn
    unix
    ;
in

{

  tarball = import ./make-tarball.nix {
    inherit nixpkgs;
    officialRelease = false;
  };

}
// (mapTestOn ({

  aspell = all;
  at = linux;
  autoconf = all;
  automake = all;
  avahi = unix; # Cygwin builds fail
  bash = all;
  bashInteractive = all;
  bc = all;
  binutils = linux;
  bind = linux;
  bsdiff = all;
  bzip2 = all;
  cmake = all;
  coreutils = all;
  cpio = all;
  cron = linux;
  cups = linux;
  dbus = linux;
  diffutils = all;
  e2fsprogs = linux;
  emacs = linux;
  file = all;
  findutils = all;
  flex = all;
  gcc = all;
  glibc = linux;
  glibcLocales = linux;
  gnugrep = all;
  gnum4 = all;
  gnumake = all;
  gnupatch = all;
  gnupg = linux;
  gnuplot = unix; # Cygwin builds fail
  gnused = all;
  gnutar = all;
  gnutls = linux;
  grub2 = linux;
  guile = linux; # tests fail on Cygwin
  gzip = all;
  hddtemp = linux;
  hdparm = linux;
  hello = all;
  host = linux;
  iana-etc = linux;
  icewm = linux;
  idutils = all;
  inetutils = linux;
  iputils = linux;
  qemu = linux;
  qemu_kvm = linux;
  lapack-reference = linux;
  less = all;
  lftp = all;
  libtool = all;
  libtool_2 = all;
  libxml2 = all;
  libxslt = all;
  lout = linux;
  lsof = linux;
  ltrace = linux;
  lvm2 = linux;
  lynx = linux;
  xz = linux;
  man = linux;
  man-pages = linux;
  mc = all;
  mdadm = linux;
  mesa = linux;
  mingetty = linux;
  mktemp = all;
  monotone = linux;
  mutt = linux;
  mysql = linux;
  # netcat broken on darwin
  netcat = linux;
  nfs-utils = linux;
  nix = all;
  nixUnstable = all;
  nss_ldap = linux;
  nssmdns = linux;
  ntfs3g = linux;
  ntp = linux;
  openssh = linux;
  openssl = all;
  pan = linux;
  pciutils = linux;
  perl = all;
  pkg-config = all;
  pmccabe = linux;
  procps = linux;
  python3 = unix; # Cygwin builds fail
  readline = all;
  rlwrap = all;
  rpcbind = linux;
  rsync = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  smartmontools = all;
  sqlite = unix; # Cygwin builds fail
  squid = linux;
  msmtp = linux;
  stdenv = all;
  strace = linux;
  su = linux;
  sudo = linux;
  sysklogd = linux;
  syslinux = [ "i686-linux" ];
  tcl = linux;
  tcpdump = linux;
  texinfo = all;
  time = linux;
  tinycc = linux;
  udev = linux;
  unzip = all;
  usbutils = linux;
  util-linux = linux;
  util-linuxMinimal = linux;
  w3m = all;
  wget = all;
  which = all;
  wirelesstools = linux;
  wpa_supplicant = linux;
  xfsprogs = linux;
  xkeyboard_config = linux;
  zip = all;
  tests-stdenv-gcc-stageCompare = linux;
}))
