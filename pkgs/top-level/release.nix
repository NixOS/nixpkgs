let

  allPackages = import ./all-packages.nix;

  pkgs = allPackages {};

  testOn = systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems then f (allPackages {inherit system;}) else {};
        
  testOnLinux = testOn ["i686-linux" "x86_64-linux"];

  test = testOn ["i686-linux" "x86_64-linux" "i686-darwin" "i686-cygwin"];

in {

  tarball = import ./make-tarball.nix;

  /* All the top-level packages that we want to build in the build
     farm.  The notation is still kinda clumsy.  We could use some
     meta-programming.  E.g. we would want to write
  
       wine = ["i686-linux"];

     which would be translated to

       wine = testOn ["i686-linux"] (pkgs: pkgs.wine);

     Shouldn't be too hard to make a function that recurses over the
     attrset and does this for every attribute. */

  MPlayer = testOnLinux (pkgs: pkgs.MPlayer);
  autoconf = test (pkgs: pkgs.autoconf);
  bash = test (pkgs: pkgs.bash);
  firefox3 = testOnLinux (pkgs: pkgs.firefox3);
  gcc = test (pkgs: pkgs.gcc);
  hello = test (pkgs: pkgs.hello);
  libsmbios = testOnLinux (pkgs: pkgs.libsmbios);
  libtool = test (pkgs: pkgs.libtool);
  pan = testOnLinux (pkgs: pkgs.pan);
  perl = test (pkgs: pkgs.perl);
  python = test (pkgs: pkgs.python);
  thunderbird = testOnLinux (pkgs: pkgs.thunderbird);
  wine = testOn ["i686-linux"] (pkgs: pkgs.wine);

  xorg = {
    libX11 = testOnLinux (pkgs: pkgs.xorg.libX11);    
  };

  kde42 = {
    kdeadmin = testOnLinux (pkgs: pkgs.kde42.kdeadmin);
    kdeartwork = testOnLinux (pkgs: pkgs.kde42.kdeartwork);
    kdebase = testOnLinux (pkgs: pkgs.kde42.kdebase);
    kdebase_runtime = testOnLinux (pkgs: pkgs.kde42.kdebase_runtime);
    kdebase_workspace = testOnLinux (pkgs: pkgs.kde42.kdebase_workspace);
    kdeedu = testOnLinux (pkgs: pkgs.kde42.kdeedu);
    kdegames = testOnLinux (pkgs: pkgs.kde42.kdegames);
    kdegraphics = testOnLinux (pkgs: pkgs.kde42.kdegraphics);
    kdelibs = testOnLinux (pkgs: pkgs.kde42.kdelibs);
    kdemultimedia = testOnLinux (pkgs: pkgs.kde42.kdemultimedia);
    kdenetwork = testOnLinux (pkgs: pkgs.kde42.kdenetwork);
    kdepim = testOnLinux (pkgs: pkgs.kde42.kdepim);
    kdeplasma_addons = testOnLinux (pkgs: pkgs.kde42.kdeplasma_addons);
    kdesdk = testOnLinux (pkgs: pkgs.kde42.kdesdk);
    kdetoys = testOnLinux (pkgs: pkgs.kde42.kdetoys);
    kdeutils = testOnLinux (pkgs: pkgs.kde42.kdeutils);
    kdewebdev = testOnLinux (pkgs: pkgs.kde42.kdewebdev);
  };

  kernelPackages_2_6_27 = {
    aufs = testOnLinux (pkgs: pkgs.kernelPackages_2_6_27.aufs);
    kernel = testOnLinux (pkgs: pkgs.kernelPackages_2_6_27.kernel);
  };
  
  kernelPackages_2_6_28 = {
    aufs = testOnLinux (pkgs: pkgs.kernelPackages_2_6_28.aufs);
    kernel = testOnLinux (pkgs: pkgs.kernelPackages_2_6_28.kernel);
  };
  
}
