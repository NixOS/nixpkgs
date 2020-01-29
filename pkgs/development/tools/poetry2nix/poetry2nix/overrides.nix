{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
}:

self: super:

{
  av = super.av.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [
        pkgs.pkgconfig
      ];
      buildInputs = old.buildInputs ++ [ pkgs.ffmpeg_4 ];
    }
  );

  bcrypt = super.bcrypt.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.libffi ];
    }
  );

  cffi =
    # cffi is bundled with pypy
    if self.python.implementation == "pypy" then null else (
      super.cffi.overrideAttrs (
        old: {
          buildInputs = old.buildInputs ++ [ pkgs.libffi ];
        }
      )
    );

  cftime = super.cftime.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.cython
      ];
    }
  );

  cryptography = super.cryptography.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.openssl ];
    }
  );

  django = (
    super.django.overrideAttrs (
      old: {
        propagatedNativeBuildInputs = (old.propagatedNativeBuildInputs or [])
        ++ [ pkgs.gettext ];
      }
    )
  );

  django-bakery = super.django-bakery.overrideAttrs (
    old: {
      configurePhase = ''
        if ! test -e LICENSE; then
          touch LICENSE
        fi
      '' + (old.configurePhase or "");
    }
  );

  dlib = super.dlib.overrideAttrs (
    old: {
      # Parallel building enabled
      inherit (pkgs.python.pkgs.dlib) patches;

      enableParallelBuilding = true;
      dontUseCmakeConfigure = true;

      nativeBuildInputs = old.nativeBuildInputs ++ pkgs.dlib.nativeBuildInputs;
      buildInputs = old.buildInputs ++ pkgs.dlib.buildInputs;
    }
  );

  # Environment markers are not always included (depending on how a dep was defined)
  enum34 = if self.pythonAtLeast "3.4" then null else super.enum34;

  faker = super.faker.overrideAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace 'setup_requires=["pytest-runner"],' 'setup_requires=[],' || true
      '';
    }
  );

  grandalf = super.grandalf.overrideAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace "setup_requires=['pytest-runner',]," "setup_requires=[]," || true
      '';
    }
  );

  horovod = super.horovod.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [ pkgs.openmpi ];
    }
  );

  # importlib-metadata has an incomplete dependency specification
  importlib-metadata = super.importlib-metadata.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ lib.optional self.python.isPy2 self.pathlib2;
    }
  );

  lap = super.lap.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        self.numpy
      ];
    }
  );

  llvmlite = super.llvmlite.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.llvm ];

      # Disable static linking
      # https://github.com/numba/llvmlite/issues/93
      postPatch = ''
        substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

        substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
      '';

      # Set directory containing llvm-config binary
      preConfigure = ''
        export LLVM_CONFIG=${pkgs.llvm}/bin/llvm-config
      '';

      __impureHostDeps = pkgs.stdenv.lib.optionals pkgs.stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

      passthru = old.passthru // { llvm = pkgs.llvm; };
    }
  );

  lockfile = super.lockfile.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.pbr ];
    }
  );

  lxml = super.lxml.overrideAttrs (
    old: {
      nativeBuildInputs = with pkgs; old.nativeBuildInputs ++ [ pkgconfig libxml2.dev libxslt.dev ];
      buildInputs = with pkgs; old.buildInputs ++ [ libxml2 libxslt ];
    }
  );

  markupsafe = super.markupsafe.overrideAttrs (
    old: {
      src = old.src.override { pname = builtins.replaceStrings [ "markupsafe" ] [ "MarkupSafe" ] old.pname; };
    }
  );

  matplotlib = super.matplotlib.overrideAttrs (
    old: let
      enableGhostscript = old.passthru.enableGhostscript or false;
      enableGtk3 = old.passthru.enableTk or false;
      enableQt = old.passthru.enableQt or false;
      enableTk = old.passthru.enableTk or false;

      inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;

    in
      {
        NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${pkgs.libcxx}/include/c++/v1";

        XDG_RUNTIME_DIR = "/tmp";

        buildInputs = old.buildInputs
        ++ lib.optional enableGhostscript pkgs.ghostscript
        ++ lib.optional stdenv.isDarwin [ Cocoa ];

        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.pkgconfig
        ];

        propagatedBuildInputs = old.propagatedBuildInputs ++ [
          pkgs.libpng
          pkgs.freetype
        ]
        ++ stdenv.lib.optionals enableGtk3 [ pkgs.cairo self.pycairo pkgs.gtk3 pkgs.gobject-introspection self.pygobject3 ]
        ++ stdenv.lib.optionals enableTk [ pkgs.tcl pkgs.tk self.tkinter pkgs.libX11 ]
        ++ stdenv.lib.optionals enableQt [ self.pyqt5 ]
        ;

        inherit (super.matplotlib) patches;
      }
  );

  # Calls Cargo at build time for source builds and is really tricky to package
  maturin = super.maturin.override {
    preferWheel = true;
  };

  mccabe = super.mccabe.overrideAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace "setup_requires=['pytest-runner']," "setup_requires=[]," || true
      '';
    }
  );

  netcdf4 = super.netcdf4.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.cython
      ];

      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        pkgs.zlib
        pkgs.netcdf
        pkgs.hdf5
        pkgs.curl
        pkgs.libjpeg
      ];

      # Variables used to configure the build process
      USE_NCCONFIG = "0";
      HDF5_DIR = lib.getDev pkgs.hdf5;
      NETCDF4_DIR = pkgs.netcdf;
      CURL_DIR = pkgs.curl.dev;
      JPEG_DIR = pkgs.libjpeg.dev;
    }
  );

  numpy = super.numpy.overrideAttrs (
    old: let
      blas = old.passthru.args.blas or pkgs.openblasCompat;
      blasImplementation = lib.nameFromURL blas.name "-";
      cfg = pkgs.writeTextFile {
        name = "site.cfg";
        text = (
          lib.generators.toINI {} {
            ${blasImplementation} = {
              include_dirs = "${blas}/include";
              library_dirs = "${blas}/lib";
            } // lib.optionalAttrs (blasImplementation == "mkl") {
              mkl_libs = "mkl_rt";
              lapack_libs = "";
            };
          }
        );
      };
    in
      {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.gfortran ];
        buildInputs = old.buildInputs ++ [ blas self.cython ];
        enableParallelBuilding = true;
        preBuild = ''
          ln -s ${cfg} site.cfg
        '';
        passthru = old.passthru // {
          blas = blas;
          inherit blasImplementation cfg;
        };
      }
  );

  peewee = super.peewee.overridePythonAttrs (
    old: let
      withPostgres = old.passthru.withPostgres or false;
      withMysql = old.passthru.withMysql or false;
    in
      {
        buildInputs = old.buildInputs ++ [ self.cython pkgs.sqlite ];
        propagatedBuildInputs = old.propagatedBuildInputs
        ++ lib.optional withPostgres self.psycopg2
        ++ lib.optional withMysql self.mysql-connector;
      }
  );

  pillow = super.pillow.overrideAttrs (
    old: {
      nativeBuildInputs = [ pkgs.pkgconfig ] ++ old.nativeBuildInputs;
      buildInputs = with pkgs; [ freetype libjpeg zlib libtiff libwebp tcl lcms2 ] ++ old.buildInputs;
    }
  );

  psycopg2 = super.psycopg2.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.postgresql ];
    }
  );

  psycopg2-binary = super.psycopg2-binary.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.postgresql ];
    }
  );

  pyarrow = super.pyarrow.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.cython
      ];
    }
  );

  pycairo = (
    drv: (
      drv.overridePythonAttrs (
        _: {
          format = "other";
        }
      )
    ).overrideAttrs (
      old: {

        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.meson
          pkgs.ninja
          pkgs.pkgconfig
        ];

        propagatedBuildInputs = old.propagatedBuildInputs ++ [
          pkgs.cairo
          pkgs.xlibsWrapper
        ];

        mesonFlags = [ "-Dpython=${if self.isPy3k then "python3" else "python"}" ];
      }
    )
  ) super.pycairo;

  pycocotools = super.pycocotools.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.cython
        self.numpy
      ];
    }
  );

  pygobject = super.pygobject.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkgconfig ];
      buildInputs = old.buildInputs ++ [ pkgs.glib pkgs.gobject-introspection ];
    }
  );

  pyopenssl = super.pyopenssl.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.openssl ];
    }
  );

  pyqt5 = let
    drv = super.pyqt5;
    withConnectivity = drv.passthru.args.withConnectivity or false;
    withMultimedia = drv.passthru.args.withMultimedia or false;
    withWebKit = drv.passthru.args.withWebKit or false;
    withWebSockets = drv.passthru.args.withWebSockets or false;
  in
    super.pyqt5.overridePythonAttrs (
      old: {
        format = "other";

        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.pkgconfig
          pkgs.qt5.qmake
          pkgs.xorg.lndir
          pkgs.qt5.qtbase
          pkgs.qt5.qtsvg
          pkgs.qt5.qtdeclarative
          pkgs.qt5.qtwebchannel
          # self.pyqt5-sip
          self.sip
        ]
        ++ lib.optional withConnectivity pkgs.qt5.qtconnectivity
        ++ lib.optional withMultimedia pkgs.qt5.qtmultimedia
        ++ lib.optional withWebKit pkgs.qt5.qtwebkit
        ++ lib.optional withWebSockets pkgs.qt5.qtwebsockets
        ;

        buildInputs = old.buildInputs ++ [
          pkgs.dbus
          pkgs.qt5.qtbase
          pkgs.qt5.qtsvg
          pkgs.qt5.qtdeclarative
          self.sip
        ]
        ++ lib.optional withConnectivity pkgs.qt5.qtconnectivity
        ++ lib.optional withWebKit pkgs.qt5.qtwebkit
        ++ lib.optional withWebSockets pkgs.qt5.qtwebsockets
        ;

        # Fix dbus mainloop
        patches = pkgs.python3.pkgs.pyqt5.patches or [];

        configurePhase = ''
          runHook preConfigure

          export PYTHONPATH=$PYTHONPATH:$out/${self.python.sitePackages}

          mkdir -p $out/${self.python.sitePackages}/dbus/mainloop
          ${self.python.executable} configure.py  -w \
            --confirm-license \
            --no-qml-plugin \
            --bindir=$out/bin \
            --destdir=$out/${self.python.sitePackages} \
            --stubsdir=$out/${self.python.sitePackages}/PyQt5 \
            --sipdir=$out/share/sip/PyQt5 \
            --designer-plugindir=$out/plugins/designer

          runHook postConfigure
        '';

        postInstall = ''
          ln -s ${self.pyqt5-sip}/${self.python.sitePackages}/PyQt5/sip.* $out/${self.python.sitePackages}/PyQt5/
          for i in $out/bin/*; do
            wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
          done

          # Let's make it a namespace package
          cat << EOF > $out/${self.python.sitePackages}/PyQt5/__init__.py
          from pkgutil import extend_path
          __path__ = extend_path(__path__, __name__)
          EOF
        '';

        installCheckPhase = let
          modules = [
            "PyQt5"
            "PyQt5.QtCore"
            "PyQt5.QtQml"
            "PyQt5.QtWidgets"
            "PyQt5.QtGui"
          ]
          ++ lib.optional withWebSockets "PyQt5.QtWebSockets"
          ++ lib.optional withWebKit "PyQt5.QtWebKit"
          ++ lib.optional withMultimedia "PyQt5.QtMultimedia"
          ++ lib.optional withConnectivity "PyQt5.QtConnectivity"
          ;

          imports = lib.concatMapStrings (module: "import ${module};") modules;
        in
          ''
            echo "Checking whether modules can be imported..."
            ${self.python.interpreter} -c "${imports}"
          '';

        doCheck = true;

        enableParallelBuilding = true;
      }
    );

  pytest-datadir = super.pytest-datadir.overrideAttrs (
    old: {
      postInstall = ''
        rm -f $out/LICENSE
      '';
    }
  );

  python-prctl = super.python-prctl.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        pkgs.libcap
      ];
    }
  );

  scaleapi = super.scaleapi.overrideAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace "install_requires = ['requests>=2.4.2', 'enum34']" "install_requires = ['requests>=2.4.2']" || true
      '';
    }
  );

  # Pybind11 is an undeclared dependency of scipy that we need to pick from nixpkgs
  # Make it not fail with infinite recursion
  pybind11 = super.pybind11.overridePythonAttrs (
    old: {
      cmakeFlags = (old.cmakeFlags or []) ++ [
        "-DPYBIND11_TEST=off"
      ];
      doCheck = false; # Circular test dependency
    }
  );

  scipy = super.scipy.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.gfortran ];
      propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.pybind11 ];
      setupPyBuildFlags = [ "--fcompiler='gnu95'" ];
      enableParallelBuilding = true;
      buildInputs = old.buildInputs ++ [ self.numpy.blas ];
      preConfigure = ''
        sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
        export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
      '';
      preBuild = ''
        ln -s ${self.numpy.cfg} site.cfg
      '';
    }
  );

  scikit-learn = super.scikit-learn.overridePythonAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        pkgs.gfortran
        pkgs.glibcLocales
      ] ++ lib.optionals stdenv.cc.isClang [
        pkgs.llvmPackages.openmp
      ];

      nativeBuildInputs = old.nativeBuildInputs ++ [
        self.cython
      ];

      enableParallelBuilding = true;
    }
  );

  shapely = super.shapely.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.geos self.cython ];
      inherit (pkgs.python3.pkgs.shapely) patches GEOS_LIBRARY_PATH;
    }
  );

  urwidtrees = super.urwidtrees.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        self.urwid
      ];
    }
  );

  vose-alias-method = super.vose-alias-method.overrideAttrs (
    old: {
      postInstall = ''
        rm -f $out/LICENSE
      '';
    }
  );

  uvloop = super.uvloop.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ lib.optionals stdenv.isDarwin [
        pkgs.darwin.apple_sdk.frameworks.ApplicationServices
        pkgs.darwin.apple_sdk.frameworks.CoreServices
      ];
    }
  );

  # Stop infinite recursion by using bootstrapped pkg from nixpkgs
  wheel = (
    pkgs.python3.pkgs.override {
      python = self.python;
    }
  ).wheel.overridePythonAttrs (
    _: {
      inherit (super.wheel) pname name version src;
    }
  );

  zipp =
    if lib.versionAtLeast super.zipp.version "2.0.0" then (
      super.zipp.overridePythonAttrs (
        old: {
          prePatch = ''
            substituteInPlace setup.py --replace \
            'setuptools.setup()' \
            'setuptools.setup(version="${super.zipp.version}")'
          '';
        }
      )
    ) else super.zipp;

}
