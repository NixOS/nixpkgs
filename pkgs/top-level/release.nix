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

in {

  tarball = import ./make-tarball.nix;

} // mapTestOn {

  MPlayer = linux;
  apacheHttpd = linux;
  autoconf = all;
  bash = all;
  firefox3 = linux;
  gcc = all;
  hello = all;
  libsmbios = linux;
  libtool = all;
  pan = linux;
  perl = all;
  python = all;
  thunderbird = linux;
  vlc = linux;
  wine = ["i686-linux"];

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
