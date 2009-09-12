let

  allPackages = import ./all-packages.nix;

  pkgs = allPackages {};

  /* Set the Hydra scheduling priority for a job.  The default
     priority (100) should be used for most jobs.  A different
     priority should only be used for a few particularly interesting
     jobs (in terms of giving feedback to developers), such as stdenv.
  */
  prio = level: job: toJob job // { schedulingPriority = level; };

  toJob = x: if builtins.isAttrs x then x else
    { type = "job"; systems = x; schedulingPriority = 10; };

  /* Perform a job on the given set of platforms.  The function `f' is
     called by Hydra for each platform, and should return some job
     to build on that platform.  `f' is passed the Nixpkgs collection
     for the platform in question. */
  testOn = systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems then f (allPackages {inherit system;}) else {};

  /* Map an attribute of the form `foo = [platforms...]'  to `testOn
     [platforms...] (pkgs: pkgs.foo)'. */
  mapTestOn = pkgs.lib.mapAttrsRecursiveCond
    (as: !(as ? type && as.type == "job"))
    (path: value:
      let
        job = toJob value;
        getPkg = pkgs:
          pkgs.lib.addMetaAttrs { schedulingPriority = toString job.schedulingPriority; }
          (pkgs.lib.getAttrFromPath path pkgs);
      in testOn job.systems getPkg);

  selectMaintained = attrSet: 
    if builtins  ? tryEval then 
      let pairs = pkgs.lib.concatMap 
        (x: let val = builtins.tryEval (processPackage (builtins.getAttr x attrSet)); in
          if val.success && val.value != [] then [{name=x; value=val.value;}] else [])
        (builtins.attrNames attrSet);
      in
        builtins.listToAttrs pairs
    else {};
  # May fail as much as it wishes, we will catch the error
  processPackage = attrSet: 
    if attrSet ? recurseForDerivations && attrSet.recurseForDerivations then 
      selectMaintained attrSet
    else
      if attrSet.meta.maintainers != [] then 
        attrSet.meta.platforms
      else
        []; 

  /* Common platform groups on which to test packages. */
  inherit (pkgs.lib.platforms) linux darwin cygwin allBut all;

  /* Platform groups for specific kinds of applications. */
  x11Supported = linux;
  gtkSupported = linux;
  ghcSupported = linux ++ darwin;

in {

  tarball = import ./make-tarball.nix;

} // (mapTestOn ((selectMaintained pkgs) // rec {

  MPlayer = linux;
  abcde = linux;
  alsaUtils = linux;
  apacheHttpd = linux;
  aspell = all;
  at = linux;
  aterm25 = all;
  aterm28 = all;
  audacious = linux;
  audacious_plugins = linux;
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
  compiz = linux;
  console_kit = linux;
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
  dmtx = all;
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
  emacs22 = all;
  emacs23 = all;
  enscript = all;
  eprover = linux;
  evince = linux;
  expect = linux;
  exult = linux;
  fbterm = linux;
  feh = linux;
  file = all;
  findutils = all;
  firefox2 = linux;
  firefox3 = prio 150 linux;
  firefox35 = linux;
  flex = all;
  flex2535 = all;
  fontforge = linux;
  fuse = linux;
  gajim = linux;
  gawk = all;
  gcc = all;
  gcc33 = linux;
  gcc34 = linux;
  gcc42 = linux;
  gcc43_multi = ["x86_64-linux"];
  gcc44 = linux;
  gcj44 = linux;
  gdb = all;
  ghostscript = linux;
  ghostscriptX = linux;
  gimp = linux;
  git = linux;
  glibc = linux;
  glibcLocales = linux;
  glxinfo = linux;
  gnash = linux;
  gnugrep = all;
  gnum4 = all;
  gnumake = all;
  gnupatch = all;
  gnupg2 = linux;
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
  idutils = all;
  ifplugd = linux;
  imagemagick = allBut "i686-cygwin";
  impressive = linux;
  inetutils = linux;
  inkscape = linux;
  iputils = linux;
  iproute = linux;
  irssi = linux;
  jfsUtils = linux;
  jfsrec = linux;
  jnettop = linux;
  jwhois = linux;
  k3b = linux;
  kbd = linux;
  kcachegrind = linux;
  keen4 = ["i686-linux"];
  kile = linux;
  klibc = linux;
  konversation = linux;
  ktorrent = linux;
  kvm = linux;
  qemu = linux;
  less = all;
  lftp = all;
  libarchive = linux;
  libsmbios = linux;
  libtool = all;
  libtool_2 = all;
  libtopology = all;
  libxml2 = all;
  libxslt = all;
  linuxwacom = linux;
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
  mesa = linux ++ darwin;
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
  policy_kit = linux;
  portmap = linux;
  postgresql = all;
  postfix = linux;
  ppl = all;
  procps = linux;
  pwdutils = linux;
  pthreadmanpages = all;
  pygtk = linux;
  python = allBut "i686-cygwin";
  pythonFull = linux;
  sbcl = all;
  qt3 = allBut "i686-cygwin";
  qt4 = linux;
  qt45 = linux;
  quake3demo = linux;
  readline = all;
  reiserfsprogs = linux;
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
  splashutils_13 = linux;
  splashutils_15 = linux;
  sqlite = allBut "i686-cygwin";
  squid = linux;
  ssmtp = linux;
  stdenv = prio 175 all;
  stlport = linux;
  strace = linux;
  su = linux;
  subversion = all;
  subversion16 = all;
  sudo = linux;
  superTuxKart = linux;
  swig = linux;
  sylpheed = linux;
  sysklogd = linux;
  syslinux = ["i686-linux"];
  sysvinit = linux;
  sysvtools = linux;
  tahoe = linux;
  tangogps = linux;
  tcl = linux;
  tcpdump = linux;
  teeworlds = linux;
  tetex = linux;
  texLive = linux;
  texLiveBeamer = linux;
  texLiveExtra = linux;
  texinfo = all;
  thunderbird = linux;
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
  valgrind = linux;
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
  wine = ["i686-linux"];
  wireshark = linux;
  wirelesstools = linux;
  wpa_supplicant = linux;
  wxGTK = all;
  x11_ssh_askpass = linux;
  xchm = linux;
  xfig = x11Supported;
  xfsProgs = linux;
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

  gnome = {
    gconfeditor = linux;
    gnomepanel = linux;
    gnometerminal = linux;
    gnomeutils = linux;
    metacity = linux;
  };

  gtkLibs = {
    gtk = linux;
  };

  haskellPackages_ghc683 = {
    ghc = ghcSupported;
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
    haskellPlatform = linux; /* OpenGL/mesa seems to fail on darwin */
    xmonad = linux;
  };

  kde3 = {
    kdebase = linux;
    kdelibs = linux;
  };

  kde42 = {
    amarok = linux;
    kdeadmin = linux;
    kdeartwork = linux;
    kdebase = linux;
    kdebase_runtime = linux;
    kdebase_workspace = linux;
    kdeedu = linux;
    kdegames = linux;
    kdegraphics = linux;
    kdelibs = linux;
    kdemultimedia = linux;
    kdenetwork = linux;
    kdepim = linux;
    kdeplasma_addons = linux;
    kdesdk = linux;
    kdetoys = linux;
    kdeutils = linux;
    kdewebdev = linux;
    ktorrent = linux;
    kdesvn = linux;
    krusader = linux;
  };

  kde43 = {
    kdelibs = linux;
    kdelibs_experimental = linux;
    kdebase_workspace = linux;
    kdebase = linux;
    kdebase_runtime = linux;
    oxygen_icons = linux;
    kdepimlibs = linux;
    kdeadmin = linux;
    kdeartwork = linux;
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
    kdesvn = linux;
    amarok = linux;
  };

  kernelPackages_2_6_25 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
  };

  kernelPackages_2_6_26 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
  };
  
  kernelPackages_2_6_27 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
  };
  
  kernelPackages_2_6_28 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
  };

  kernelPackages_2_6_29 = {
    aufs = linux;
    kernel = linux;
    virtualbox = linux;
  };

  kernelPackages_2_6_31 = {
    kernel = linux;
  };

  kernelPackages_2_6_31_rc4 = {
    aufs = linux;
    kernel = linux;
  };

  kernelPackages_2_6_31_rc4_old_i686 = {
    aufs = ["i686-linux"];
    kernel = ["i686-linux"];
  };

  kernelPackages_2_6_31_rc2 = {
    aufs = linux;
    kernel = linux;
  };

  kernelPackages_2_6_31_rc2_old_i686 = {
    aufs = ["i686-linux"];
    kernel = ["i686-linux"];
  };

  strategoPackages = {
    sdf = all;
    strategoxt = all;
    javafront = all;
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
