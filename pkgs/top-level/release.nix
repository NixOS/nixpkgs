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
  bazaar = all;
  bitlbee = all;
  boost = all;
  cdrkit = linux;
  cedet = all;
  emacs22 = all;
  emacsUnicode = all;
  emms = all;
  eprover = linux;
  evince = all;
  firefox3 = linux;
  gcc = all;
  gdb = all;
  ghostscript = all;
  ghostscriptX = all;
  git = all;
  gnuplot = all;
  gnuplotX = linux;
  gnutls = all;
  graphviz = all;
  guile = linux;  # tests fail on Cygwin
  guileLib = linux;
  hello = all;
  icecat3Xul = [ "i686-linux" ];
  idutils = all;
  inetutils = linux;
  jnettop = linux;
  libsmbios = linux;
  libtool = all;
  lsh = linux;
  manpages = all;
  maxima = all;
  mercurial = all;
  monotone = all;
  mysql = all;
  nano = all;
  nssmdns = linux;
  octave = all;
  openoffice = linux;
  openssh = all;
  pan = linux;
  perl = all;
  pltScheme = linux;
  pmccabe = all;
  portmap = linux;
  postgresql = all;
  python = all;
  ruby = all;
  qt3 = all;
  qt4 = all;
  rsync = all;
  sloccount = all;
  strace = linux;
  subversion = linux;
  tcpdump = linux;
  thunderbird = linux;
  vimHugeX = all;
  vlc = linux;
  webkit = all;
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
    aufs = linux;
    kernel = linux;
  };
  
  kernelPackages_2_6_28 = {
    aufs = linux;
    kernel = linux;
  };
  
  xorg = {
    libX11 = linux;
  };

}
