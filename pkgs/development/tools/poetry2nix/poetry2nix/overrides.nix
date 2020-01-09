{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
}:

self: super:

let

  addSetupTools = drv: if drv == null then null else drv.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.setuptools_scm
      ];
    }
  );

  getAttrDefault = attribute: set: default:
    if builtins.hasAttr attribute set
    then builtins.getAttr attribute set
    else default;

in
{

  asciimatics = super.asciimatics.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.setuptools_scm
      ];
    }
  );

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

  cffi = super.cffi.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.libffi ];
    }
  );

  cftime = super.cftime.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.cython
      ];
    }
  );

  configparser = addSetupTools super.configparser;

  cbor2 = addSetupTools super.cbor2;

  cryptography = super.cryptography.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.openssl ];
    }
  );

  django = (
    super.django.overrideAttrs (
      old: {
        propagatedNativeBuildInputs = (getAttrDefault "propagatedNativeBuildInputs" old [])
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
      '' + (getAttrDefault "configurePhase" old "");
    }
  );

  # Environment markers are not always included (depending on how a dep was defined)
  enum34 = if self.pythonAtLeast "3.4" then null else super.enum34;

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

  hypothesis = addSetupTools super.hypothesis;

  importlib-metadata = addSetupTools super.importlib-metadata;

  inflect = super.inflect.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.setuptools_scm
      ];
    }
  );

  jsonschema = addSetupTools super.jsonschema;

  keyring = addSetupTools super.keyring;

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
    old: {
      NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${pkgs.libcxx}/include/c++/v1";

      XDG_RUNTIME_DIR = "/tmp";

      nativeBuildInputs = old.nativeBuildInputs ++ [
        pkgs.pkgconfig
      ];

      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        pkgs.libpng
        pkgs.freetype
      ];

      inherit (super.matplotlib) patches;
    }
  );

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
      blas = pkgs.openblasCompat;
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
        buildInputs = old.buildInputs ++ [ blas ];
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

  pillow = super.pillow.overrideAttrs (
    old: {
      nativeBuildInputs = [ pkgs.pkgconfig ] ++ old.nativeBuildInputs;
      buildInputs = with pkgs; [ freetype libjpeg zlib libtiff libwebp tcl lcms2 ] ++ old.buildInputs;
    }
  );

  pluggy = addSetupTools super.pluggy;

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

  py = addSetupTools super.py;

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

  pytest = addSetupTools super.pytest;

  pytest-mock = addSetupTools super.pytest-mock;

  python-dateutil = addSetupTools super.python-dateutil;

  python-prctl = super.python-prctl.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [
        self.setuptools_scm
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

  scipy = super.scipy.overrideAttrs (
    old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.gfortran ];
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

  shapely = super.shapely.overrideAttrs (
    old: {
      buildInputs = old.buildInputs ++ [ pkgs.geos self.cython ];
      inherit (super.shapely) patches GEOS_LIBRARY_PATH;
    }
  );

  six = addSetupTools super.six;

  urwidtrees = super.urwidtrees.overrideAttrs (
    old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        self.urwid
      ];
    }
  );

  # TODO: Figure out getting rid of this hack
  wheel = (
    pkgs.python3.pkgs.override {
      python = self.python;
    }
  ).wheel.overridePythonAttrs (
    _: {
      inherit (super.wheel) pname name version src;
    }
  );

  zipp = addSetupTools super.zipp;
}
