/* A small release file, with few packages to be built.  The aim is to reduce
   the load on Hydra when testing the `stdenv-updates' branch.


   This file will be evaluated by hydra with a call like this:
   hydra_eval_jobs --gc-roots-dir \
     /nix/var/nix/gcroots/per-user/hydra/hydra-roots --argstr \
     system i686-linux --argstr system x86_64-linux --arg \
     nixpkgs "{outPath = ./}" .... release.nix

   Hydra can be installed with "nix-env -i hydra".  */
with (import ./release-lib.nix);

{

  tarball = import ./make-tarball.nix;

} // (mapTestOn (rec {

  aspell = all;
  at = linux;
  aterm25 = all;
  aterm28 = all;
  autoconf = all;
  automake110x = all;
  automake111x = all;
  avahi = allBut "i686-cygwin";  # Cygwin builds fail
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
  emacs23 = gtkSupported;
  enscript = all;
  file = all;
  findutils = all;
  flex = all;
  flex2535 = all;
  gcc = all;
  gcc33 = linux;
  gcc34 = linux;
  gcc42 = linux;
  gcc43_multi = ["x86_64-linux"];
  gcc44 = linux;
  gcj44 = linux;
  ghdl = linux;
  glibc = linux;
  glibcLocales = linux;
  gnat44 = linux;
  gnugrep = all;
  gnum4 = all;
  gnumake = all;
  gnupatch = all;
  gnupg = linux;
  gnuplot = allBut "i686-cygwin";
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
  icecat3Xul = linux;
  icewm = linux;
  idutils = all;
  ifplugd = linux;
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
  manpages = linux;
  mc = all;
  mcabber = linux;
  mcron = linux;
  mdadm = linux;
  mesa = mesaPlatforms;
  midori = linux;
  mingetty = linux;
  mk = linux;
  mktemp = all;
  module_init_tools = linux;
  mono = linux;
  monotone = linux;
  mpg321 = linux;
  mutt = linux;
  mysql = linux;
  mysql51 = linux;
  ncat = linux;
  netcat = all;
  nfsUtils = linux;
  nix = all;
  nixUnstable = all;
  nss_ldap = linux;
  nssmdns = linux;
  ntfs3g = linux;
  ntp = linux;
  openssh = linux;
  openssl = all;
  pam_console = linux;
  pam_login = linux;
  pan = gtkSupported;
  par2cmdline = all;
  pciutils = linux;
  pdf2xml = all;
  perl = all;
  pkgconfig = all;
  pmccabe = linux;
  policykit = linux;
  portmap = linux;
  procps = linux;
  python = allBut "i686-cygwin";
  pythonFull = linux;
  readline = all;
  rlwrap = all;
  rpm = linux;
  rsync = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  sharutils = all;
  sloccount = allBut "i686-cygwin";
  smartmontools = all;
  splashutils = linux;
  sqlite = allBut "i686-cygwin";
  squid = linux;
  ssmtp = linux;
  stdenv = prio 175 all;
  strace = linux;
  su = linux;
  sudo = linux;
  sysklogd = linux;
  syslinux = ["i686-linux"];
  sysvinit = linux;
  sysvtools = linux;
  tcl = linux;
  tcpdump = linux;
  tetex = linux;
  texLive = linux;
  texLiveBeamer = linux;
  texLiveExtra = linux;
  texinfo = all;
  time = linux;
  tinycc = ["i686-linux"];
  udev = linux;
  unrar = linux;
  unzip = all;
  upstart = linux;
  usbutils = linux;
  utillinux = linux;
  utillinuxCurses = linux;
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

  dbus_all = {
    libs = linux;
    tools = linux;
  };

  emacs23Packages = {
    bbdb = linux;
    cedet = linux;
    ecb = linux;
    emacsw3m = linux;
    emms = linux;
  };
} ))
