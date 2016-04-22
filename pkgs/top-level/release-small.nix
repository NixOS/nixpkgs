/* A small release file, with few packages to be built.  The aim is to reduce
   the load on Hydra when testing the `stdenv-updates' branch. */

{ nixpkgs ? { outPath = (import ./../.. {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" ]
}:

with import ./release-lib.nix { inherit supportedSystems; };

{

  tarball = import ./make-tarball.nix {
    inherit nixpkgs;
    officialRelease = false;
  };

} // (mapTestOn (rec {

  aspell = all;
  at = linux;
  atlas = linux;
  aterm25 = all;
  autoconf = all;
  automake = all;
  avahi = allBut cygwin;  # Cygwin builds fail
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
  dhcp = linux;
  diffutils = all;
  e2fsprogs = linux;
  emacs24 = gtkSupported;
  enscript = all;
  file = all;
  findutils = all;
  flex = all;
  gcc = all;
  gcj = linux;
  glibc = linux;
  glibcLocales = linux;
  gnat = linux;
  gnugrep = all;
  gnum4 = all;
  gnumake = all;
  gnupatch = all;
  gnupg = linux;
  gnuplot = allBut cygwin;
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
  iana_etc = linux;
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
  netcat = all;
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
  portmap = linux;
  procps = linux;
  python = allBut cygwin;
  pythonFull = linux;
  readline = all;
  rlwrap = all;
  rpm = linux;
  rsync = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  sharutils = all;
  sloccount = allBut cygwin;
  smartmontools = all;
  sqlite = allBut cygwin;
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
  texLive = linux;
  texLiveBeamer = linux;
  texLiveExtra = linux;
  texinfo = all;
  time = linux;
  tinycc = linux;
  udev = linux;
  unrar = linux;
  unzip = all;
  upstart = linux;
  usbutils = linux;
  utillinux = linux;
  utillinuxMinimal = linux;
  w3m = all;
  webkit = linux;
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

  dbus = {
    libs = linux;
    daemon = linux;
    tools = linux;
  };

} ))
