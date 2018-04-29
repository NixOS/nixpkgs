self:

with self;

# These are default overrides and should not be used directly in
# Nixpkgs. They are mainly for convenience for users and backward
# compatibility. There is no plan to remove these, but the hope is
# that we will eventually have such great support for "feature flags"
# that these will no longer be necessary.

# NOTE that while the plan is to references to these, currently quite
# a few are used as dependencies in all-packages.nix.

let mapOverrides = lib.mapAttrs (n: lowPrio);

in mapOverrides (rec {
  aseprite-unfree = aseprite.override { unfree = true; };
  arduino-core = arduino.override { withGui = false; };
  amuleDaemon = appendToName "daemon" (amule.override {
    monolithic = false;
    daemon = true;
  });
  amuleGui = appendToName "gui" (amule.override {
    monolithic = false;
    client = true;
  });
  asciidoc-full = appendToName "full" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
  });
  asciidoc-full-with-plugins = appendToName "full-with-plugins" (asciidoc.override {
    inherit (python2Packages) pygments;
    enableStandardFeatures = true;
    enableExtraPlugins = true;
  });
  coreutils-prefixed = coreutils.override {
    withPrefix = true;
    singleBinary = false;
  };
  chromiumBeta = chromium.override { channel = "beta"; };
  chromiumDev = chromium.override { channel = "dev"; };
  cmakeCurses = cmake.override { useNcurses = true; };
  cmakeWithGui = cmakeCurses.override { withQt5 = true; };
  cmakeWithQt4Gui = cmakeCurses.override { useQt4 = true; };
  crawlTiles = crawl.override { tileMode = true; };
  construoBase = construo.override { libGL = null; freeglut = null; };
  curlFull = curl.override {
    idnSupport = true;
    ldapSupport = true;
    gssSupport = true;
    brotliSupport = true;
  };
  dblatexFull = appendToName "full" (dblatex.override {
    enableAllFeatures = true;
  });
  dwarf-fortress = dwarf-fortress-packages.dwarf-fortress.override { };
  dwarf-therapist = dwarf-fortress-packages.dwarf-therapist;
  doxygen_gui = doxygen.override { inherit qt4; };
  emacs25-nox = appendToName "nox" (emacs25.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  });
  fftwSinglePrec = fftw.override { precision = "single"; };
  fftwLongDouble = fftw.override { precision = "long-double"; };
  flashplayer-standalone-debugger = flashplayer-standalone.override {
    debug = true;
  };
  gap-minimal = gap.override { keepAllPackages = false; };
  gtk2-x11 = gtk2.override { gdktarget = "x11"; };
  glib-tested = glib.override {
    doCheck = true;
    libffi = libffi.override { doCheck = true; };
  };
  gmpxx = appendToName "with-cxx" (gmp.override { cxx = true; });
  google-chrome-beta = google-chrome.override {
    chromium = chromiumBeta;
    channel = "beta";
  };
  google-chrome-dev = google-chrome.override {
    chromium = chromiumDev;
    channel = "dev";
  };
  ghostscriptX = appendToName "with-X" (ghostscript.override {
    cupsSupport = true;
    x11Support = true;
  });
  graphviz-nox = graphviz.override { xorg = null; libdevil = libdevil-nox; };
  gpm-ncurses = gpm.override { inherit ncurses; };
  grub2_efi = grub2.override { efiSupport = true; };
  grub2_light = grub2.override { zfsSupport = false; };
  grub2_xen = grub2.override { xenSupport = true; };
  gnuplot_qt = gnuplot.override { withQt = true; };
  gnuplot_aquaterm = gnuplot.override { aquaterm = true; };
  gitMinimal = git.override {
    withManual = false;
    pythonSupport = false;
    withpcre2 = false;
  };
  giac-with-xcas = giac.override { enableGUI = true; };
  harfbuzz-icu = harfbuzz.override { withIcu = true; withGraphite2 = true; };
  harfbuzz-icu-58 = harfbuzz-icu.override { icu = icu58; };
  hplipWithPlugin = hplip.override { withPlugin = true; };
  hplipWithPlugin_3_16_11 = hplip.override { withPlugin = true; };
  hdf5-mpi = appendToName "mpi" (hdf5.override { szip = null; mpi = openmpi; });
  hdf5-cpp = appendToName "cpp" (hdf5.override { cpp = true; });
  hdf5-fortran = appendToName "fortran" (hdf5.override {
    inherit gfortran;
  });
  hdf5-threadsafe = appendToName "threadsafe" (hdf5.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags
                   ++ ["--enable-threadsafe" "--disable-hl" ];
  }));
  imagemagickBig = imagemagick.override { inherit ghostscript; };
  imagemagick_light = imagemagick.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
  };
  imagemagick7_light = imagemagick7.override {
    bzip2 = null;
    zlib = null;
    libX11 = null;
    libXext = null;
    libXt = null;
    fontconfig = null;
    freetype = null;
    ghostscript = null;
    libjpeg = null;
    lcms2 = null;
    openexr = null;
    libpng = null;
    librsvg = null;
    libtiff = null;
    libxml2 = null;
    openjpeg = null;
    libwebp = null;
  };
  imagemagick7Big = imagemagick7.override { inherit ghostscript; };
  imlib2-nox = imlib2.override { x11Support = false; };
  jackmix_jack1 = jackmix.override { jack = jack1; };
  kubectl = (kubernetes.override { components = [ "cmd/kubectl" ]; })
            .overrideAttrs(oldAttrs: {
              name = "kubectl-${oldAttrs.version}";
            });
  lammps-mpi = appendToName "mpi" (lammps.override {
    mpiSupport = true;
    mpi = openmpi;
  });
  libffado = ffado.override { prefix = "lib"; };
  libheimdal = heimdal.override { type = "lib"; };
  libpulseaudio = pulseaudio.override {
    libOnly = true;
  };
  liblapackWithoutAtlas = liblapack.override { atlas = null; };
  liblapack_3_5_0WithoutAtlas = liblapack.override { atlas = null; };
  libjack2 = jack2.override { prefix = "lib"; };
  lilyterm-git = lilyterm.override { flavour = "git"; };
  lightdm_qt = lightdm.override { withQt5 = true; };
  libva1-minimal = libva1.override { minimal = true; };
  libva-minimal = libva.override { minimal = true; };
  libv4l = v4l_utils.override { withUtils = false; };
  libpng_apng = libpng.override { apngSupport = true; };
  libgpgerror-gen-posix-lock-obj = libgpgerror.override {
    genPosixLockObjOnly = true;
  };
  libdevil-nox = libdevil.override { libX11 = null; libGL = null; };
  libdbiDriversBase = libdbiDrivers.override { mysql = null; sqlite = null; };
  libcanberra-gtk3 = libcanberra.override { gtk = gtk3; };
  libcanberra-gtk2 = libcanberra-gtk3.override { gtk = gtk2; };
  libkrb5 = krb5.override {
    fetchurl = fetchurlBoot;
    type = "lib";
  };
  mutt-with-sidebar = mutt.override { withSidebar = true; };
  mesa_drivers = (mesa_noglu.override {
    grsecEnabled = config.grsecurity or false;
    enableTextureFloats = true;
  }).drivers;
  mercurialFull = appendToName "full" (mercurial.override {
    guiSupport = true;
  });
  mjpegtoolsFull = mjpegtools.override { withMinimal = false; };
  neuron-mpi = appendToName "mpi" (neuron.override { mpi = openmpi; });
  neuron-full = neuron-mpi.override { inherit python; mpi = openmpi; };
  netcdf-mpi = appendToName "mpi" (netcdf.override { hdf5 = hdf5-mpi; });
  openssh_hpn = appendToName "with-hpn" (openssh.override {
    hpnSupport = true;
  });
  openblasCompat = openblas.override { blas64 = false; };
  open-vm-tools-headless = open-vm-tools.override { withX = false; };
  openntpd_nixos = openntpd.override {
    privsepUser = "ntp"; privsepPath = "/var/empty";
  };
  opencv3WithoutCuda = opencv3.override { enableCuda = false; };
  openconnect_gnutl = openconnect.override { openssl = null; };
  openconnect_openssl = openconnect.override { gnutls = null; };
  pgpool93 = pgpool.override { postgresql = postgresql93; };
  pgpool94 = pgpool.override { postgresql = postgresql94; };
  pkgconfigUpstream = pkgconfig.override { vanilla = true; };
  php71-embed = php71.override {
    config.php.embed = true; config.php.apxs2 = false;
  };
  php72-embed = php72.override {
    config.php.embed = true; config.php.apxs2 = false;
  };
  pinentry_ncurses = pinentry.override { gtk2 = null; };
  pinentry_emacs = pinentry_ncurses.override { enableEmacs = true; };
  pinentry_gnome = pinentry_ncurses.override { gcr = gnome3.gcr; };
  pinentry_qt4 = pinentry_ncurses.override { qt = qt4; };
  pinentry_qt5 = pinentry_ncurses.override { qt = qt5.qtbase; };
  pythonFull = python.override { x11Support=true; };
  python2Full = python2.override { x11Support=true; };
  python27Full = python27.override { x11Support=true; };
  python3Full = python3.override { x11Support=true; };
  python34Full = python34.override { x11Support=true; };
  python35Full = python35.override { x11Support=true; };
  python36Full = python36.override { x11Support=true; };
  poppler_gi = poppler.override { introspectionSupport = true; };
  poppler_min = poppler.override { minimal = true; suffix = "min"; };
  poppler_utils = poppler.override { suffix = "utils"; utils = true; };
  pcre16 = pcre.override { variant = "pcre16"; };
  pcre-cpp = pcre.override { variant = "cpp"; };
  pulseaudioFull = pulseaudio.override {
    gconf = gnome3.gconf;
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    gconfSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };
  raxml-mpi = appendToName "mpi" (raxml.override { mpi = true; });
  qemu_kvm = qemu.override { hostCpuOnly = true; };
  qemu_xen = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen-slim;
  };
  qemu_xen-light = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen-light;
  };
  qemu_xen_4_8 = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen_4_8-slim;
  };
  qemu_xen_4_8-light = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen_4_8-light;
  };
  qemu_xen_4_10 = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen_4_10-slim;
  };
  qemu_xen_4_10-light = qemu.override {
    hostCpuOnly = true;
    xenSupport = true;
    xen = xen_4_10-light;
  };
  qemu_test = qemu.override { hostCpuOnly = true; nixosTestRunner = true; };
  quazip_qt4 = libsForQt5.quazip.override {
    qtbase = qt4;
    qmake = qmake4Hook;
  };
  qt48Full = appendToName "full" (qt48.override {
    docs = true;
    demos = true;
    examples = true;
    developerBuild = true;
  });
  quasselClient = quassel.override {
    monolithic = false; client = true; tag = "-client-kf5";
  };
  quasselDaemon = quassel.override {
    monolithic = false;
    daemon = true;
    tag = "-daemon-qt5";
    withKDE = false;
  };
  quodlibet-without-gst-plugins = quodlibet.override {
    withGstPlugins = false;
    tag = "-without-gst-plugins";
  };
  quodlibet-xine = quodlibet.override { xineBackend = true; tag = "-xine"; };
  quodlibet-full = quodlibet.override {
    inherit (gnome3) gtksourceview webkitgtk;
    withDbusPython = true;
    withPyInotify = true;
    withMusicBrainzNgs = true;
    withPahoMqtt = true;
    keybinder3 = keybinder3;
    libmodplug = libmodplug;
    kakasi = kakasi;
    libappindicator-gtk3 = libappindicator-gtk3;
    tag = "-full";
  };
  quodlibet-xine-full = quodlibet-full.override {
    xineBackend = true;
    tag = "-xine-full";
  };
  riscv-pk-with-kernel = riscv-pk.override {
    payload = "${linux_riscv}/vmlinux";
  };
  rtmpdump_gnutls = rtmpdump.override {
    gnutlsSupport = true;
    opensslSupport = false;
  };
  rocksdb_lite = rocksdb.override { enableLite = true; };
  samba3_light = samba3.override {
    pam = null;
    fam = null;
    cups = null;
    acl = null;
    openldap = null;
    libunwind = null;
  };
  samba4Full = samba4.override {
    enableInfiniband = true;
    enableLDAP = true;
    enablePrinting = true;
    enableMDNS = true;
    enableDomainController = true;
    enableRegedit = true;
    enableCephFS = true;
    enableGlusterFS = true;
  };
  sambaFull = samba4Full;
  steam = steamPackages.steam-chrootenv.override {
    withJava = config.steam.java or false;
    withPrimus = config.steam.primus or false;
  };
  steam-run-native = (steam.override {
    nativeOnly = true;
  }).run;
  stumpwm-git = stumpwm.override {
    version = "git"; inherit sbcl lispPackages;
  };
  sqlite-interactive = appendToName "interactive"
                       (sqlite.override { interactive = true; }).bin;
  supercollider_scel = supercollider.override { useSCEL = true; };
  subversionClient = appendToName "client" (subversion.override {
    bdbSupport = false;
    perlBindings = true;
    pythonBindings = true;
  });
  systemd_with_lvm2 = appendToName "with-lvm2" (systemd.overrideAttrs (p: {
    postInstall = p.postInstall + ''
      cp ${lvm2}/lib/systemd/system-generators/* \
         $out/lib/systemd/system-generators
    '';
  }));
  suil-qt4 = suil.override { withQt4 = true; withQt5 = false; };
  transmission-gtk = transmission.override { enableGTK3 = true; };
  texinfoInteractive = appendToName "interactive" (
    texinfo.override { interactive = true; }
  );
  teensyduino = arduino.override {
    withGui = true;
    withTeensyduino = true;
  };
  ttfautohint-nox = ttfautohint.override { enableGUI = false; };
  ucommon_gnutls = ucommon.override {
    openssl = null;
    zlib = null;
    gnutls = gnutls;
  };
  unzipNLS = unzip.override { enableNLS = true; };
  valgrind-light = valgrind.override { gdb = null; };
  vimNox = vim_configurable.override { source = "vim-nox"; };
  verasco = ocaml-ng.ocamlPackages_4_02.verasco.override { coq = coq_8_4; };
  virtualboxHardened = virtualbox.override { enableHardening = true; };
  virtualboxHeadless = virtualbox.override {
    enableHardening = true; headless = true;
  };
  vtkWithQt4 = vtk.override { qtLib = qt4; };
  v8_static = v8.override { static = true; };
  wireshark-gtk = wireshark.override { withGtk = true; };
  wireshark-qt = wireshark.override { withQt = true; };
  wireshark-cli = wireshark.override { withQt = true; };
  wine-staging = winePackages.full.override { wineRelease = "staging"; };
  webkitgtk24x-gtk2 = webkitgtk24x-gtk3.override {
    withGtk2 = true;
    enableIntrospection = false;
  };
  w3m-nox = w3m.override { x11Support = false; imlib2 = imlib2-nox; };
  w3m-batch = w3m.override {
    graphicsSupport = false;
    mouseSupport = false;
    x11Support = false;
    imlib2 = imlib2-nox;
  };
  zandronum-server = zandronum.override { serverOnly = true; };
})
