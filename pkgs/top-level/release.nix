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

  MPlayer = linux;
  abcde = linux;
  alsaUtils = linux;
  apacheHttpd = linux;
  aspell = all;
  at = linux;
  aterm242fixes = all;
  aterm25 = all;
  aterm28 = all;
  audacious = linux;
  autoconf = all;
  automake110x = all;
  automake111x = all;
  automake19x = all;
  avahi = allBut "i686-cygwin";  # Cygwin builds fail
  bash = all;
  bashInteractive = all;
  bazaar = linux; # first let sqlite3 work on darwin
  bc = all;
  binutils = linux;
  bind = linux;
  bison23 = all;
  bison24 = all;
  bitlbee = linux;
  bittorrent = linux;
  blender = linux;
  boost = all;
  boostFull = all;
  bsdiff = all;
  btrfsProgs = linux;
  bvi = all;
  bzip2 = all;
  cabextract = all;
  castleCombat = linux;
  cdrkit = linux;
  chatzilla = linux;
  cksfv = all;
  classpath = linux;
  cmake = all;
  #compiz = linux;
  consolekit = linux;
  coreutils = all;
  cpio = all;
  cron = linux;
  cups = linux;
  cvs = linux;
  db4 = all;
  ddrescue = linux;
  dhcp = linux;
  dico = linux;
  dietlibc = linux;
  diffutils = all;
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
  gcc = all;
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
  gimp = linux;
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
  guileLib = linux;
  gv = linux;
  gw6c = linux;
  gzip = all;
  hal = linux;
  hal_info = linux;
  hddtemp = linux;
  hdparm = linux;
  hello = all;
  host = linux;
  htmlTidy = all;
  hugin = linux;
  iana_etc = linux;
  icecat3Xul = linux;
  icewm = linux;
  idutils = all;
  ifplugd = linux;
  imagemagick = allBut "i686-cygwin";
  impressive = linux;
  inetutils = linux;
  inkscape = linux;
  iputils = linux;
  iproute = linux;
  iptables = linux;
  irssi = linux;
  jfsutils = linux;
  jfsrec = linux;
  jnettop = linux;
  jwhois = linux;
  kbd = linux;
  keen4 = ["i686-linux"];
  klibc = linux;
  ktorrent = linux;
  kvm = linux;
  qemu = linux;
  qemu_kvm = linux;
  less = all;
  lftp = all;
  libarchive = linux;
  libsmbios = linux;
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
  maxima = linux;
  mc = all;
  mcabber = linux;
  mcron = linux;
  mdadm = linux;
  mercurial = allBut "i686-cygwin";
  mesa = mesaPlatforms;
  midori = linux;
  mingetty = linux;
  mk = linux;
  mktemp = all;
  mod_python = linux;
  module_init_tools = linux;
  mono = linux;
  monotone = linux;
  mpg321 = linux;
  mutt = linux;
  mysql = linux;
  mysql51 = linux;
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
  pam_ldap = linux;
  pam_login = linux;
  pam_unix2 = linux;
  pan = gtkSupported;
  par2cmdline = all;
  pavucontrol = linux;
  pciutils = linux;
  perl = all;
  php = linux;
  pidgin = linux;
  pinentry = linux;
  pkgconfig = all;
  pltScheme = linux;
  pmccabe = linux;
  policykit = linux;
  portmap = linux;
  postgresql = all;
  postfix = linux;
  ppl = all;
  procps = linux;
  pwdutils = linux;
  pthreadmanpages = all;
  pygtk = linux;
  pyqt4 = linux;
  python = allBut "i686-cygwin";
  pythonFull = linux;
  sbcl = all;
  qt3 = linux;
  qt4 = linux;
  qt45 = linux;
  qt46 = linux;
  quake3demo = linux;
  readline = all;
  reiserfsprogs = linux;
  rlwrap = all;
  rogue = all;
  rpm = linux;
  rsync = linux;
  rubber = allBut "i686-cygwin";
  ruby = all;
  rxvt_unicode = all;
  samba = linux;
  screen = linux ++ darwin;
  scrot = linux;
  sdparm = linux;
  seccure = linux;
  sgtpuzzles = linux;
  sharutils = all;
  slim = linux;
  sloccount = allBut "i686-cygwin";
  smartmontools = all;
  smbfsFuse = linux;
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
  thunderbird2 = linux;
  thunderbird3 = linux;
  tightvnc = linux;
  time = linux;
  tinycc = ["i686-linux"];
  udev = linux;
  uml = ["i686-linux"];
  unrar = linux;
  unzip = all;
  upstart = linux;
  usbutils = linux;
  utillinux = linux;
  utillinuxCurses = linux;
  uzbl = linux;
  viking = linux;
  vice = linux;
  vim = linux;
  vimHugeX = linux;
  vlc = linux;
  vncrec = linux;
  vorbisTools = linux;
  vpnc = linux;
  vsftpd = linux;
  w3m = all;
  webkit = linux;
  wget = all;
  which = all;
  wicd = linux;
  wine = ["i686-linux"];
  wireshark = linux;
  wirelesstools = linux;
  wpa_supplicant = linux;
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

  aspellDicts = {
    de = all;
    en = all;
    es = all;
    fr = all;
    nl = all;
    ru = all;
  };

  dbus = {
    libs = linux;
    tools = linux;
  };

  emacs22Packages = {
    bbdb = linux;
    cedet = linux;
    ecb = linux;
    emacsw3m = linux;
    emms = linux;
    nxml = all;
  };

  emacs23Packages = emacs22Packages // {
    jdee = linux;
  };

  firefox35Pkgs = {
    firefox = prio 150 linux;
  };

  firefox36Pkgs = {
    firefox = linux;
  };

  gnome = {
    gnome_panel = linux;
    metacity = linux;
    gnome_vfs = linux;
  };

  gtkLibs = {
    gtk = linux;
  };

  haskellPackages_ghc6102 = {
    ghc = ghcSupported;
  };

  haskellPackages_ghc6103 = {
    ghc = ghcSupported;
  };

  haskellPackages_ghc6104 = {
    darcs = ghcSupported;
    ghc = ghcSupported;
    gtk2hs = linux;
    leksah = linux;
    lhs2tex = ghcSupported;
    haskellPlatform = ghcSupported;
    xmonad = linux;
    gitit = linux;
  };

  haskellPackages_ghc6121 = {
    darcs = ghcSupported;
    ghc = ghcSupported;
    haskellPlatform2010100 = ghcSupported;
  };

  haskellPackages_ghc6122 = {
    darcs = ghcSupported;
    ghc = ghcSupported;
    haskellPlatform2010100 = ghcSupported;
  };

  kde3 = {
    kdebase = linux;
    kdelibs = linux;
    k3b = linux;
    kcachegrind = linux;
    kile = linux;
  };

  kde44 = {
    kdelibs = linux;
    kdebase_workspace = linux;
    kdebase = linux;
    kdebase_runtime = linux;
    oxygen_icons = linux;
    kdepimlibs = linux;
    kdeadmin = linux;
    kdeartwork = linux;
    kdeaccessibility = linux;
    kdeedu = linux;
    kdegraphics = linux;
    kdemultimedia = linux;
    kdenetwork = linux;
    kdepim = linux;
    kdepim_runtime = linux;
    kdeplasma_addons = linux;
    kdegames = linux;
    kdetoys = linux;
    kdeutils = linux;
    kdesdk = linux;
    kdewebdev = linux;
    krusader = linux;
    kmplayer = linux;
    ktorrent = linux;
    koffice = linux;
    konversation = linux;
    kdesvn = linux;
    amarok = linux;
    l10n.ca = linux;
    l10n.de = linux;
    l10n.fr = linux;
    l10n.nl = linux;
    l10n.ru = linux;
  };

  linuxPackages_2_6_25 = {
    aufs = linux;
    kernel = linux;
  };

  linuxPackages_2_6_27 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
    virtualboxGuestAdditions = linux;
  };

  linuxPackages_2_6_28 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
    virtualboxGuestAdditions = linux;
  };

  linuxPackages_2_6_29 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
    virtualboxGuestAdditions = linux;
  };

  linuxPackages_2_6_32 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
    virtualboxGuestAdditions = linux;
  };

  linuxPackages_2_6_33 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
    virtualboxGuestAdditions = linux;
  };

  strategoPackages = {
    sdf = all;
    strategoxt = all;
    javafront = all;
    strategoShell = linux ++ darwin;
    dryad = linux;
  };

  strategoPackages018 = {
    sdfStatic = all;
    sdf = all;
    strategoxt = all;
    javafront = all;
    aspectjfront = all;
    strategoShell = all;
    dryad = linux;
  };

  perlPackages = {
    TaskCatalystTutorial = linux;
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
    xev = linux;
    xf86inputkeyboard = linux;
    xf86inputmouse = linux;
    xf86inputevdev = linux;
    xf86inputsynaptics = linux;
    xf86videoati = linux;
    xf86videointel = linux;
    xf86videonv = linux;
    xf86videovesa = linux;
    xfs = linux;
    xkbcomp = linux;
    xmessage = linux;
    xorgserver = linux;
    xrandr = linux;
    xrdb = linux;
    xset = linux;
  };

} ))

