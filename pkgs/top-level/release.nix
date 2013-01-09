/*
  This file will be evaluated by hydra with a call like this:
  hydra_eval_jobs --gc-roots-dir \
    /nix/var/nix/gcroots/per-user/hydra/hydra-roots --argstr \
    system i686-linux --argstr system x86_64-linux --arg \
    nixpkgs "{outPath = ./}" .... release.nix

  Hydra can be installed with "nix-env -i hydra".
*/
with (import ./release-lib.nix);

{

  tarball = import ./make-tarball.nix;

} // (mapTestOn ((packagesWithMetaPlatform pkgs) // rec {

  abcde = linux;
  alsaUtils = linux;
  apacheHttpd = linux;
  aspell = all;
  at = linux;
  aterm25 = all;
  aterm28 = all;
  audacious = linux;
  autoconf = all;
  automake110x = all;
  automake111x = all;
  avahi = allBut "i686-cygwin";  # Cygwin builds fail
  bash = all;
  bashInteractive = all;
  bazaar = linux; # first let sqlite3 work on darwin
  bc = all;
  binutils = linux;
  bind = linux;
  bison23 = all;
  bison24 = all;
  bison25 = all;
  bitlbee = linux;
  bittorrent = linux;
  blender = linux;
  bsdiff = all;
  btrfsProgs = linux;
  bvi = all;
  bzip2 = all;
  cabextract = all;
  castle_combat = linux;
  cdrkit = linux;
  chatzilla = linux;
  cksfv = all;
  classpath = linux;
  consolekit = linux;
  coreutils = all;
  cpio = all;
  cron = linux;
  cvs = linux;
  db4 = all;
  ddrescue = linux;
  dhcp = linux;
  dico = linux;
  dietlibc = linux;
  diffutils = all;
  disnix = all;
  disnixos = linux;
  DisnixWebService = linux;
  docbook5 = all;
  docbook5_xsl = all;
  docbook_xml_dtd_42 = all;
  docbook_xml_dtd_43 = all;
  docbook_xsl = all;
  dosbox = linux;
  dovecot = linux;
  doxygen = linux;
  dpkg = linux;
  drgeo = linux;
  e2fsprogs = linux;
  ejabberd = linux;
  elinks = linux;
  emacs22 = gtkSupported;
  emacs23 = gtkSupported;
  enscript = all;
  eprover = linux;
  evince = linux;
  expect = linux;
  exult = linux;
  fbterm = linux;
  feh = linux;
  file = all;
  findutils = all;
  flex = all;
  flex2535 = all;
  fontforge = linux;
  fuse = linux;
  gajim = linux;
  gawk = all;
  gcc = linux;
  gcc33 = linux;
  gcc34 = linux;
  gcc41 = linux;
  gcc42 = linux;
  gcc43_multi = ["x86_64-linux"];
  gcc44 = linux;
  gcj44 = linux;
  ghdl = linux;
  ghostscript = linux;
  ghostscriptX = linux;
  gimp_2_8 = linux;
  git = linux;
  gitFull = linux;
  glibc = linux;
  glibcLocales = linux;
  glxinfo = linux;
  gnash = linux;
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
  gphoto2 = linux;
  gpm = linux;
  gprolog = linux;
  gpsbabel = all;
  gpscorrelate = linux;
  gpsd = linux;
  gqview = gtkSupported;
  graphviz = all;
  grub = linux;
  grub2 = linux;
  gsl = linux;
  guile = linux;  # tests fail on Cygwin
  gv = linux;
  gzip = all;
  hddtemp = linux;
  hello = all;
  host = linux;
  htmlTidy = all;
  hugin = linux;
  iana_etc = linux;
  icecat3Xul = linux;
  icewm = linux;
  idutils = all;
  ifplugd = linux;
  impressive = linux;
  inetutils = linux;
  inkscape = linux;
  iputils = linux;
  irssi = linux;
  jfsutils = linux;
  jfsrec = linux;
  jnettop = linux;
  jwhois = linux;
  kbd = linux;
  keen4 = ["i686-linux"];
#  klibc = linux;
  kvm = linux;
  qemu = linux;
  qemu_kvm = linux;
  less = all;
  lftp = all;
  libarchive = linux;
  libsmbios = linux;
  libtool = all;
  libtool_2 = all;
  lout = linux;
  lsh = linux;
  lsof = linux;
  ltrace = linux;
  lvm2 = linux;
  lynx = linux;
  lzma = linux;
  man = linux;
  manpages = linux;
  maxima = linux;
  mc = linux;
  mcabber = linux;
  mcron = linux;
  mdadm = linux;
  mercurial = allBut "i686-cygwin";
  mercurialFull = allBut "i686-cygwin";
  mesa = mesaPlatforms;
  midori = linux;
  mingetty = linux;
  mk = linux;
  mktemp = all;
  mod_python = linux;
  module_init_tools = linux;
  mono = linux;
  mpg321 = linux;
  mupen64plus = linux;
  mutt = linux;
  mysql = linux;
  mysql51 = linux;
  mysql55 = linux;
  namazu = all;
  nano = allBut "i686-cygwin";
  ncat = linux;
  netcat = all;
  nfsUtils = linux;
  nix = all;
  nixUnstable = all;
  nmap = linux;
  nss_ldap = linux;
  nssmdns = linux;
  ntfs3g = linux;
  ntp = linux;
  ocaml = linux;
  octave = linux;
  openoffice = linux;
  openssh = linux;
  openssl = all;
  pam_console = linux;
  pam_login = linux;
  pam_unix2 = linux;
  pan = gtkSupported;
  par2cmdline = all;
  pavucontrol = linux;
  pciutils = linux;
  pdf2xml = all;
  perl = all;
  php = linux;
  pidgin = linux;
  pinentry = linux;
  pltScheme = linux;
  pmccabe = linux;
  portmap = linux;
  postgresql = all;
  postfix = linux;
  ppl = all;
  procps = linux;
  pwdutils = linux;
  pthreadmanpages = linux;
  pygtk = linux;
  pyqt4 = linux;
  python = allBut "i686-cygwin";
  pythonFull = linux;
  sbcl = linux;
  qt3 = linux;
  quake3demo = linux;
  readline = all;
  reiserfsprogs = linux;
  rlwrap = all;
  rogue = all;
  rpm = linux;
  rsync = linux;
  rubber = allBut "i686-cygwin";
  ruby = all;
  rxvt_unicode = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  seccure = linux;
  sgtpuzzles = linux;
  sharutils = all;
  slim = linux;
  sloccount = allBut "i686-cygwin";
  smartmontools = linux;
  socat = linux;
  spidermonkey = linux;
  splashutils = linux;
  sqlite = allBut "i686-cygwin";
  squid = linux;
  ssmtp = linux;
  stdenv = prio 175 all;
  stlport = linux;
  strace = linux;
  su = linux;
  sudo = linux;
  superTuxKart = linux;
  swig = linux;
  sylpheed = linux;
  sysklogd = linux;
  syslinux = ["i686-linux"];
  sysvinit = linux;
  sysvtools = linux;
  tahoelafs = linux;
  tangogps = linux;
  tcl = linux;
  tcpdump = linux;
  teeworlds = linux;
  tetex = linux;
  texLive = linux;
  texLiveBeamer = linux;
  texLiveExtra = linux;
  texinfo = all;
  tightvnc = linux;
  time = linux;
  tinycc = ["i686-linux"];
  uae = linux;
  udev = linux;
  unrar = linux;
  upstart = linux;
  usbutils = linux;
  utillinux = linux;
  utillinuxCurses = linux;
  uzbl = linux;
  viking = linux;
  vice = linux;
  vim = linux;
  vimHugeX = linux;
  VisualBoyAdvance = linux;
  vlc = linux;
  vncrec = linux;
  vorbisTools = linux;
  vpnc = linux;
  vsftpd = linux;
  w3m = all;
  webkit = linux;
  weechat = linux;
  wget = all;
  which = all;
  wicd = linux;
  wine = ["i686-linux"];
  wireshark = linux;
  wirelesstools = linux;
  wxGTK = linux;
  x11_ssh_askpass = linux;
  xchm = linux;
  xfig = x11Supported;
  xfsprogs = linux;
  xineUI = linux;
  xkeyboard_config = linux;
  xlockmore = linux;
  xmltv = linux;
  xpdf = linux;
  xscreensaver = linux;
  xsel = linux;
  xterm = linux;
  xxdiff = linux;
  zdelta = linux;
  zile = linux;
  zip = all;
  zsh = linux;
  zsnes = ["i686-linux"];

  emacs22Packages = {
    bbdb = linux;
    cedet = linux;
    ecb = linux;
    emacsw3m = linux;
    emms = linux;
  };

  emacs23Packages = emacs22Packages // {
    jdee = linux;
  };

  firefox36Pkgs.firefox = linux;
  firefox17Pkgs.firefox = linux;

  gnome = {
    gnome_panel = linux;
    metacity = linux;
    gnome_vfs = linux;
  };

  /*
  haskellPackages_ghc6104 = {
    ghc = ghcSupported;
    haskellPlatform_2009_2_0_2 = ghcSupported;
  };

  haskellPackages_ghc6121 = {
    ghc = ghcSupported;
    haskellPlatform_2010_1_0_0 = ghcSupported;
  };

  haskellPackages_ghc6123 = {
    ghc = ghcSupported;
    gitit = linux;
    gtk = linux;
    haskellPlatform = ghcSupported;
  };

  haskellPackages_ghc701 = {
    ghc = ghcSupported;
  };

  haskellPackages_ghc702 = {
    ghc = ghcSupported;
    haskellPlatform = ghcSupported;
  };

  haskellPackages_ghc704 = {
    darcs = ghcSupported;
    ghc = ghcSupported;
    gitit = linux;
    gtk = linux;
    haskellPlatform = ghcSupported;
    lhs2tex = ghcSupported;
    xmonad = linux;
  };
  */

  strategoPackages = {
    sdf = linux;
    strategoxt = linux;
    javafront = linux;
    strategoShell = linux ++ darwin;
    dryad = linux;
  };

  pythonPackages = {
    zfec = linux;
  };

  xorg = {
    fontadobe100dpi = linux;
    fontadobe75dpi = linux;
    fontbh100dpi = linux;
    fontbhlucidatypewriter100dpi = linux;
    fontbhlucidatypewriter75dpi = linux;
    fontbhttf = linux;
    fontcursormisc = linux;
    fontmiscmisc = linux;
    iceauth = linux;
    libX11 = linux;
    lndir = all;
    setxkbmap = linux;
    xauth = linux;
    xbitmaps = linux;
    xev = linux;
    xf86inputevdev = linux;
    xf86inputkeyboard = linux;
    xf86inputmouse = linux;
    xf86inputsynaptics = linux;
    xf86videoati = linux;
    xf86videocirrus = linux;
    xf86videointel = linux;
    xf86videonv = linux;
    xf86videovesa = linux;
    xfs = linux;
    xkbcomp = linux;
    xlsclients = linux;
    xmessage = linux;
    xorgserver = linux;
    xprop = linux;
    xrandr = linux;
    xrdb = linux;
    xset = linux;
    xsetroot = linux;
    xwininfo = linux;
  };

  xfce = {
    gtk_xfce_engine = linux;
    mousepad = linux;
    ristretto = linux;
    terminal = linux;
    thunar = linux;
    xfce4_power_manager = linux;
    xfce4icontheme = linux;
    xfce4mixer = linux;
    xfce4panel = linux;
    xfce4session = linux;
    xfce4settings = linux;
    xfceutils = linux;
    xfdesktop = linux;
    xfwm4 = linux;
  };

} ))
