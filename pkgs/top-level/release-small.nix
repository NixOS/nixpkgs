/* A small release file, with few packages to be built.  The aim is to reduce
   the load on Hydra when testing the `stdenv-updates' branch. */

{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
}:

with import ./release-lib.nix { inherit supportedSystems; };

{

  tarball = import ./make-tarball.nix {
    inherit nixpkgs;
    officialRelease = false;
  };

} // (mapTestOn ({

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
  classpath = linux;
  cmake = all;
  coreutils = all;
  cpio = all;
  cron = linux;
  cups = linux;
  dbus = linux;
  dhcp = linux;
  diffutils = all;
  e2fsprogs = linux;
  emacs25 = gtkSupported;
  enscript = all;
  file = all;
  findutils = all;
  flex = all;
  gcc = all;
  gcj = linux;
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
  gogoclient = linux;
  grub = linux;
  grub2 = linux;
  gsl = linux;
  guile = linux;  # tests fail on Cygwin
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
  jnettop = linux;
  jwhois = linux;
  kbd = linux;
  keen4 = ["i686-linux"];
  kvm = linux;
  qemu = linux;
  qemu_kvm = linux;
  less = all;
  lftp = all;
  liblapack = linux;
  libtool = all;
  libtool_2 = all;
  libxml2 = all;
  libxslt = all;
  lout = linux;
  lsh = linux;
  lsof = linux;
  ltrace = linux;
  lvm2 = linux;
  lynx = linux;
  lzma = linux;
  man = linux;
  man-pages = linux;
  mc = all;
  mcabber = linux;
  mcron = linux;
  mdadm = linux;
  mesa = mesaPlatforms;
  midori = linux;
  mingetty = linux;
  mk = linux;
  mktemp = all;
  mono = linux;
  monotone = linux;
  mpg321 = linux;
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
  pan = gtkSupported;
  par2cmdline = all;
  pciutils = linux;
  pdf2xml = all;
  perl = all;
  pkgconfig = all;
  pmccabe = linux;
  procps = linux;
  python = unix; # Cygwin builds fail
  readline = all;
  rlwrap = all;
  rpm = linux;
  rpcbind = linux;
  rsync = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  sharutils = all;
  sloccount = unix; # Cygwin builds fail
  smartmontools = all;
  sqlite = unix; # Cygwin builds fail
  squid = linux;
  ssmtp = linux;
  stdenv = all;
  strace = linux;
  su = linux;
  sudo = linux;
  sysklogd = linux;
  syslinux = ["i686-linux"];
  sysvinit = linux;
  sysvtools = linux;
  tcl = linux;
  tcpdump = linux;
  texinfo = all;
  time = linux;
  tinycc = linux;
  udev = linux;
  unzip = all;
  usbutils = linux;
  utillinux = linux;
  utillinuxMinimal = linux;
  w3m = all;
  webkitgtk = linux;
  wget = all;
  which = all;
  wicd = linux;
  wireshark = linux;
  wirelesstools = linux;
  wpa_supplicant = linux;
  xfsprogs = linux;
  xkeyboard_config = linux;
  zile = linux;
  zip = all;

} ))
