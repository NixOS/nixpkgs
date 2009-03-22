let

  allPackages = import ./all-packages.nix;

  pkgs = allPackages {};

  /* Perform a job on the given set of platforms.  The function `f' is
     called by Hydra for each platform, and should return some job
     to build on that platform.  `f' is passed the Nixpkgs collection
     for the platform in question. */
  testOn = systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems then f (allPackages {inherit system;}) else {};

  /* Map an attribute of the form `foo = [platforms...]'  to `testOn
     [platforms...] (pkgs: pkgs.foo)'. */
  mapTestOn = pkgs.lib.mapAttrsRecursive
    (path: value: testOn value (pkgs: pkgs.lib.getAttrFromPath path pkgs));

  /* Common platform groups on which to test packages. */
  all = ["i686-linux" "x86_64-linux" "i686-darwin" "i686-cygwin"];
  linux = ["i686-linux" "x86_64-linux"];
  allBut = (platform: pkgs.lib.filter (x: platform != x) all);

in {

  tarball = import ./make-tarball.nix;

} // mapTestOn {

  MPlayer = linux;
  apacheHttpd = linux;
  at = linux;
  autoconf = all;
  avahi = allBut "i686-cygwin";  # Cygwin builds fail
  bash = all;
  bazaar = linux; # first let sqlite3 work on darwin
  bitlbee = linux; 
  boost = all;
  castleCombat = linux;
  cdrkit = linux;
  cedet = linux;
  compiz = linux;
  compizFusion = linux;
  emacs22 = all;
  emacsUnicode = all;
  emms = linux;
  eprover = linux;
  evince = linux;
  firefox3 = linux;
  gcc = all;
  gdb = all;
  ghostscript = linux;
  ghostscriptX = linux;
  gimp = linux;
  git = linux;
  gnuplot = allBut "i686-cygwin";
  gnuplotX = linux;
  gnutls = linux;
  graphviz = all;
  guile = linux;  # tests fail on Cygwin
  guileLib = linux;
  hello = all;
  icecat3Xul = [ "i686-linux" ];
  idutils = all;
  imagemagick = allBut "i686-cygwin";
  impressive = linux;
  inetutils = linux;
  inkscape = linux;
  jnettop = linux;
  kernel_2_6_28 = linux;
  libsmbios = linux;
  libtool = all;
  lout = linux;
  lsh = linux;
  manpages = all;
  maxima = linux;
  mercurial = allBut "i686-cygwin";
  mesa = linux;
  mono = linux;
  monotone = linux;
  mysql = linux;
  nano = allBut "i686-cygwin";
  nssmdns = linux;
  ntfs3g = linux;
  octave = linux;
  openoffice = linux;
  openssh = linux;
  pan = linux;
  perl = all;
  pidgin = linux;
  pltScheme = linux;
  pmccabe = linux;
  portmap = linux;
  postgresql = all;
  python = allBut "i686-cygwin";
  pythonFull = linux;
  rubber = allBut "i686-cygwin";
  ruby = all;
  qt3 = allBut "i686-cygwin";
  qt4 = linux;
  rsync = linux;
  sloccount = allBut "i686-cygwin";
  sqlite = allBut "i686-cygwin";
  strace = linux;
  subversion = linux;
  superTuxKart = linux;
  tcpdump = linux;
  teeworlds = linux;
  texinfo = all;
  texLive = linux;
  thunderbird = linux;
  vimHugeX = linux;
  vlc = linux;
  webkit = linux;
  wine = ["i686-linux"];
  wirelesstools = linux;
  xlockmore = linux;
  xpdf = linux;
  zile = linux;

  gtkLibs = {
    gtk = linux;
  };

  kde42 = {
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
  };

  kernelPackages_2_6_27 = {
    # aufs = linux; # kernel seems to be too old for that package 
    kernel = linux;
  };
  
  kernelPackages_2_6_28 = {
    aufs = linux;
    kernel = linux;
  };
  
  xorg = {
    libX11 = linux;
    xorgserver = linux;
  };

}
