{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
}:

self: super:

{
  automat = super.automat.overridePythonAttrs (
    old: rec {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.m2r ];
    }
  );

  aiohttp-swagger3 = super.aiohttp-swagger3.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  ansible = super.ansible.overridePythonAttrs (
    old: {
      # Inputs copied from nixpkgs as ansible doesn't specify it's dependencies
      # in a correct manner.
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        self.pycrypto
        self.paramiko
        self.jinja2
        self.pyyaml
        self.httplib2
        self.six
        self.netaddr
        self.dnspython
        self.jmespath
        self.dopy
        self.ncclient
      ];
    } // lib.optionalAttrs (lib.versionOlder old.version "5.0") {
      prePatch = pkgs.python.pkgs.ansible.prePatch or "";
      postInstall = pkgs.python.pkgs.ansible.postInstall or "";
    }
  );

  ansible-lint = super.ansible-lint.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools-scm-git-archive ];
      preBuild = ''
        export HOME=$(mktemp -d)
      '';
    }
  );

  anyio = super.anyio.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace 'setup()' 'setup(version="${old.version}")'
    '';
  });

  argcomplete = super.argcomplete.overridePythonAttrs (
    old: rec {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.importlib-metadata ];
    }
  );

  arpeggio = super.arpeggio.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  astroid = super.astroid.overridePythonAttrs (
    old: rec {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  av = super.av.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs.pkg-config
      ];
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.ffmpeg_4 ];
    }
  );

  argon2-cffi = super.argon2-cffi.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++
        lib.optional (lib.versionAtLeast old.version "21.2.0") [ self.flit-core ];
    }
  );

  backports-entry-points-selectable = super.backports-entry-points-selectable.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace \
        'setuptools.setup()' \
        'setuptools.setup(version="${old.version}")'
    '';
  });

  backports-functools-lru-cache = super.backports-functools-lru-cache.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace \
        'setuptools.setup()' \
        'setuptools.setup(version="${old.version}")'
    '';
  });

  bcrypt = super.bcrypt.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libffi ];
    }
  );

  bjoern = super.bjoern.overridePythonAttrs (
    old: {
      buildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.libev ];
    }
  );

  black = super.black.overridePythonAttrs (
    old: {
      dontPreferSetupPy = true;
    }
  );

  borgbackup = super.borgbackup.overridePythonAttrs (
    old: {
      BORG_OPENSSL_PREFIX = pkgs.openssl.dev;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl pkgs.acl ];
    }
  );

  cairocffi = super.cairocffi.overridePythonAttrs (
    old: {
      inherit (pkgs.python3.pkgs.cairocffi) patches;
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  cairosvg = super.cairosvg.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  celery = super.celery.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
  });

  cssselect2 = super.cssselect2.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  cffi =
    # cffi is bundled with pypy
    if self.python.implementation == "pypy" then null else
    (
      super.cffi.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libffi ];
        }
      )
    );

  cftime = super.cftime.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.cython
      ];
    }
  );

  cheroot = super.cheroot.overridePythonAttrs (
    old: {
      dontPreferSetupPy = true;
    }
  );

  cloudflare = super.cloudflare.overridePythonAttrs (
    old: {
      postPatch = ''
        rm -rf examples/*
      '';
    }
  );

  colour = super.colour.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.d2to1 ];
    }
  );

  configparser = super.configparser.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.toml
      ];

      postPatch = ''
        substituteInPlace setup.py --replace 'setuptools.setup()' 'setuptools.setup(version="${old.version}")'
      '';
    }
  );

  cryptography = super.cryptography.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ])
        ++ lib.optional (lib.versionAtLeast old.version "3.4") [ self.setuptools-rust ]
        ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) self.python.pythonForBuild.pkgs.cffi
        ++ lib.optional (lib.versionAtLeast old.version "3.5")
        (with pkgs.rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl ];
    } // lib.optionalAttrs (lib.versionAtLeast old.version "3.4" && lib.versionOlder old.version "3.5") {
      CRYPTOGRAPHY_DONT_BUILD_RUST = "1";
    } // lib.optionalAttrs (lib.versionAtLeast old.version "35") rec {
      cargoDeps =
        let
          getCargoHash = version:
            if lib.versionOlder version "36.0.0" then "sha256-tQoQfo+TAoqAea86YFxyj/LNQCiViu5ij/3wj7ZnYLI="
            else if lib.versionOlder version "36.0.1" then "sha256-Y6TuW7AryVgSvZ6G8WNoDIvi+0tvx8ZlEYF5qB0jfNk="
            # This hash could no longer be valid for cryptography versions
            # different from 36.0.1
            else "sha256-kozYXkqt1Wpqyo9GYCwN08J+zV92ZWFJY/f+rulxmeQ=";
        in
        pkgs.rustPlatform.fetchCargoTarball {
          src = old.src;
          sourceRoot = "${old.pname}-${old.version}/${cargoRoot}";
          name = "${old.pname}-${old.version}";
          sha256 = getCargoHash old.version;
        };
      cargoRoot = "src/rust";
    }
  );

  cwcwidth = super.cwcwidth.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ])
      ++ [ self.cython ];
  });

  cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
    postPatch = ''
      substituteInPlace setup.py --replace 'setuptools>=50.3.2,<51.0.0' 'setuptools'
    '';
  });

  daphne = super.daphne.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace 'setup_requires=["pytest-runner"],' ""
    '';
  });

  datadog-lambda = super.datadog-lambda.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace "setuptools==" "setuptools>="
    '';
    buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];
  });

  dbus-python = super.dbus-python.overridePythonAttrs (old: {
    outputs = [ "out" "dev" ];

    postPatch = old.postPatch or "" + ''
      substituteInPlace ./configure --replace /usr/bin/file ${pkgs.file}/bin/file
      substituteInPlace ./dbus-python.pc.in --replace 'Cflags: -I''${includedir}' 'Cflags: -I''${includedir}/dbus-1.0'
    '';

    configureFlags = (old.configureFlags or [ ]) ++ [
      "PYTHON_VERSION=${lib.versions.major self.python.version}"
    ];

    preConfigure = lib.concatStringsSep "\n" [
      (old.preConfigure or "")
      (if (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) then ''
        MACOSX_DEPLOYMENT_TARGET=10.16
      '' else "")
    ];

    preBuild = old.preBuild or "" + ''
      make distclean
    '';

    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.pkg-config ];
    buildInputs = old.buildInputs or [ ] ++ [ pkgs.dbus pkgs.dbus-glib ]
      # My guess why it's sometimes trying to -lncurses.
      # It seems not to retain the dependency anyway.
      ++ lib.optional (! self.python ? modules) pkgs.ncurses;
  });

  dcli = super.dcli.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
  });

  ddtrace = super.ddtrace.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++
      (pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.darwin.IOKit ]) ++ [ self.cython ];
  });

  dictdiffer = super.dictdiffer.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
    }
  );

  django = (
    super.django.overridePythonAttrs (
      old: {
        propagatedNativeBuildInputs = (old.propagatedNativeBuildInputs or [ ])
          ++ [ pkgs.gettext self.pytest-runner ];
      }
    )
  );

  django-bakery = super.django-bakery.overridePythonAttrs (
    old: {
      configurePhase = ''
        if ! test -e LICENSE; then
          touch LICENSE
        fi
      '' + (old.configurePhase or "");
    }
  );

  django-cors-headers = super.django-cors-headers.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  django-hijack = super.django-hijack.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  django-prometheus = super.django-prometheus.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  django-rosetta = super.django-rosetta.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  django-stubs-ext = super.django-stubs-ext.overridePythonAttrs (
    old: {
      prePatch = (old.prePatch or "") + "touch ../LICENSE.txt";
    }
  );

  dlib = super.dlib.overridePythonAttrs (
    old: {
      # Parallel building enabled
      inherit (pkgs.python.pkgs.dlib) patches;

      enableParallelBuilding = true;
      dontUseCmakeConfigure = true;

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ pkgs.dlib.nativeBuildInputs;
      buildInputs = (old.buildInputs or [ ]) ++ pkgs.dlib.buildInputs;
    }
  );

  # Environment markers are not always included (depending on how a dep was defined)
  enum34 = if self.pythonAtLeast "3.4" then null else super.enum34;

  eth-hash = super.eth-hash.overridePythonAttrs {
    preConfigure = ''
      substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    '';
  };

  eth-keyfile = super.eth-keyfile.overridePythonAttrs {
    preConfigure = ''
      substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    '';
  };

  eth-keys = super.eth-keys.overridePythonAttrs {
    preConfigure = ''
      substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    '';
  };

  # remove eth-hash dependency because eth-hash also depends on eth-utils causing a cycle.
  eth-utils = super.eth-utils.overridePythonAttrs (old: {
    propagatedBuildInputs =
      builtins.filter (i: i.pname != "eth-hash") old.propagatedBuildInputs;
    preConfigure = ''
      ${old.preConfigure or ""}
      sed -i '/eth-hash/d' setup.py
    '';
  });

  faker = super.faker.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
      doCheck = false;
    }
  );

  fancycompleter = super.fancycompleter.overridePythonAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py \
          --replace 'setup_requires="setupmeta"' 'setup_requires=[]' \
          --replace 'versioning="devcommit"' 'version="${old.version}"'
      '';
    }
  );

  fastapi = super.fastapi.overridePythonAttrs (
    old: {
      # Note: requires full flit, not just flit-core
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.flit ];
    }
  );

  fastecdsa = super.fastecdsa.overridePythonAttrs (old: {
    buildInputs = old.buildInputs ++ [ pkgs.gmp.dev ];
  });

  fastparquet = super.fastparquet.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  filelock = super.filelock.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace 'setup()' 'setup(version="${old.version}")'
    '';
  });

  fiona = super.fiona.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.gdal_2 ];
      nativeBuildInputs = [
        pkgs.gdal_2 # for gdal-config
      ];
    }
  );

  gdal = super.gdal.overridePythonAttrs (
    old: {
      preBuild = (old.preBuild or "") + ''
        substituteInPlace setup.cfg \
          --replace "../../apps/gdal-config" '${pkgs.gdal}/bin/gdal-config'
      '';
    }
  );

  grandalf = super.grandalf.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
      doCheck = false;
    }
  );

  gitpython = super.gitpython.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.typing-extensions ];
    }
  );

  grpcio = super.grpcio.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.cython pkgs.pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.c-ares pkgs.openssl pkgs.zlib ];

    outputs = [ "out" "dev" ];

    GRPC_BUILD_WITH_BORING_SSL_ASM = "";
    GRPC_PYTHON_BUILD_SYSTEM_OPENSSL = 1;
    GRPC_PYTHON_BUILD_SYSTEM_ZLIB = 1;
    GRPC_PYTHON_BUILD_SYSTEM_CARES = 1;
    DISABLE_LIBC_COMPATIBILITY = 1;
  });

  grpcio-tools = super.grpcio-tools.overridePythonAttrs (old: {
    outputs = [ "out" "dev" ];
  });

  h3 = super.h3.overridePythonAttrs (
    old: {
      preBuild = (old.preBuild or "") + ''
        substituteInPlace h3/h3.py \
          --replace "'{}/{}'.format(_dirname, libh3_path)" '"${pkgs.h3}/lib/libh3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"'
      '';
    }
  );

  h5py = super.h5py.overridePythonAttrs (
    old:
    if old.format != "wheel" then
      (
        let
          mpi = pkgs.hdf5.mpi;
          mpiSupport = pkgs.hdf5.mpiSupport;
        in
        {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
          buildInputs =
            (old.buildInputs or [ ])
            ++ [ pkgs.hdf5 self.pkgconfig self.cython ]
            ++ lib.optional mpiSupport mpi
          ;
          propagatedBuildInputs =
            (old.propagatedBuildInputs or [ ])
            ++ lib.optionals mpiSupport [ self.mpi4py self.openssh ]
          ;
          preBuild = if mpiSupport then "export CC=${mpi}/bin/mpicc" else "";
          HDF5_DIR = "${pkgs.hdf5}";
          HDF5_MPI = if mpiSupport then "ON" else "OFF";
          # avoid strict pinning of numpy
          postPatch = ''
            substituteInPlace setup.py \
              --replace "numpy ==" "numpy >="
          '';
          pythonImportsCheck = [ "h5py" ];
        }
      ) else old
  );

  hid = super.hid.overridePythonAttrs (
    old: {
      postPatch = ''
        found=
        for name in libhidapi-hidraw libhidapi-libusb libhidapi-iohidmanager libhidapi; do
          full_path=${pkgs.hidapi.out}/lib/$name${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}
          if test -f $full_path; then
            found=t
            sed -i -e "s|'$name\..*'|'$full_path'|" hid/__init__.py
          fi
        done
        test -n "$found" || { echo "ERROR: No known libraries found in ${pkgs.hidapi.out}/lib, please update/fix this build expression."; exit 1; }
      '';
    }
  );

  horovod = super.horovod.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.mpi ];
    }
  );

  httplib2 = super.httplib2.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.pyparsing ];
  });

  icecream = super.icecream.overridePythonAttrs (old: {
    #  # ERROR: Could not find a version that satisfies the requirement executing>=0.3.1 (from icecream) (from versions: none)
    postPatch = ''
      substituteInPlace setup.py --replace 'executing>=0.3.1' 'executing'
    '';
  });

  imagecodecs = super.imagecodecs.overridePythonAttrs (
    old: {
      patchPhase = ''
        substituteInPlace setup.py \
          --replace "/usr/include/openjpeg-2.3" \
                    "${pkgs.openjpeg.dev}/include/${pkgs.openjpeg.dev.incDir}
        substituteInPlace setup.py \
          --replace "/usr/include/jxrlib" \
                    "$out/include/libjxr"
        substituteInPlace imagecodecs/_zopfli.c \
          --replace '"zopfli/zopfli.h"' \
                    '<zopfli.h>'
        substituteInPlace imagecodecs/_zopfli.c \
          --replace '"zopfli/zlib_container.h"' \
                    '<zlib_container.h>'
        substituteInPlace imagecodecs/_zopfli.c \
          --replace '"zopfli/gzip_container.h"' \
                    '<gzip_container.h>'
      '';

      preBuild = ''
        mkdir -p $out/include/libjxr
        ln -s ${pkgs.jxrlib}/include/libjxr/**/* $out/include/libjxr

      '';

      buildInputs = (old.buildInputs or [ ]) ++ [
        # Commented out packages are declared required, but not actually
        # needed to build. They are not yet packaged for nixpkgs.
        # bitshuffle
        pkgs.brotli
        # brunsli
        pkgs.bzip2
        pkgs.c-blosc
        # charls
        pkgs.giflib
        pkgs.jxrlib
        pkgs.lcms
        pkgs.libaec
        pkgs.libaec
        pkgs.libjpeg_turbo
        # liblzf
        # liblzma
        pkgs.libpng
        pkgs.libtiff
        pkgs.libwebp
        pkgs.lz4
        pkgs.openjpeg
        pkgs.snappy
        # zfp
        pkgs.zopfli
        pkgs.zstd
        pkgs.zlib
      ];
    }
  );

  # importlib-metadata has an incomplete dependency specification
  importlib-metadata = super.importlib-metadata.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ lib.optional self.python.isPy2 self.pathlib2;

      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;

      postPatch = old.postPatch or "" + (lib.optionalString ((old.format or "") != "wheel") ''
        substituteInPlace setup.py --replace 'setuptools.setup()' 'setuptools.setup(version="${old.version}")'
      '');
    }
  );

  importlib-resources = super.importlib-resources.overridePythonAttrs (
    old: {
      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;
    }
  );

  intreehooks = super.intreehooks.overridePythonAttrs (
    old: {
      doCheck = false;
    }
  );

  isort = super.isort.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
    }
  );

  jaraco-functools = super.jaraco-functools.overridePythonAttrs (
    old: {
      # required for the extra "toml" dependency in setuptools_scm[toml]
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.toml
      ];
      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;
    }
  );

  jira = super.jira.overridePythonAttrs (
    old: {
      inherit (pkgs.python3Packages.jira) patches;
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.pytestrunner
        self.cryptography
        self.pyjwt
        self.setuptools-scm-git-archive
      ];
    }
  );

  jq = super.jq.overridePythonAttrs (attrs: {
    buildInputs = [ pkgs.jq ];
    patches = [
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/088da8735f6620b60d724aa7db742607ea216087/pkgs/development/python-modules/jq/jq-py-setup.patch";
        sha256 = "sha256-MYvX3S1YGe0QsUtExtOtULvp++AdVrv+Fid4Jh1xewQ=";
      })
    ];
  });

  jsondiff = super.jsondiff.overridePythonAttrs (
    old: {
      preBuild = (old.preBuild or "") + ''
        substituteInPlace setup.py \
          --replace "'jsondiff=jsondiff.cli:main_deprecated'," ""
      '';
    }
  );

  jsonpickle = super.jsonpickle.overridePythonAttrs (
    old: {
      dontPreferSetupPy = true;
    }
  );

  jsonslicer = super.jsonslicer.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkgconfig ];
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.yajl ];
  });

  jupyter = super.jupyter.overridePythonAttrs (
    old: rec {
      # jupyter is a meta-package. Everything relevant comes from the
      # dependencies. It does however have a jupyter.py file that conflicts
      # with jupyter-core so this meta solves this conflict.
      meta.priority = 100;
    }
  );

  jupyterlab-widgets = super.jupyterlab-widgets.overridePythonAttrs (
    old: rec {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.jupyter-packaging ];
    }
  );

  kerberos = super.kerberos.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.libkrb5 ];
  });

  keyring = super.keyring.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.toml
      ];
      postPatch = ''
        substituteInPlace setup.py --replace 'setuptools.setup()' 'setuptools.setup(version="${old.version}")'
      '';
    }
  );

  kiwisolver = super.kiwisolver.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.cppy
      ];
    }
  );

  lap = super.lap.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        self.numpy
      ];
    }
  );

  libvirt-python = super.libvirt-python.overridePythonAttrs ({ nativeBuildInputs ? [ ], ... }: {
    nativeBuildInputs = nativeBuildInputs ++ [ pkgs.pkg-config ];
    propagatedBuildInputs = [ pkgs.libvirt ];
  });

  licensecheck = super.licensecheck.overridePythonAttrs (old: {
    dontPreferSetupPy = true;
  });

  llvmlite = super.llvmlite.overridePythonAttrs (
    old:
    let
      llvm =
        if lib.versionAtLeast old.version "0.37.0" then
          pkgs.llvmPackages_11.llvm
        else if (lib.versionOlder old.version "0.37.0" && lib.versionAtLeast old.version "0.34.0") then
          pkgs.llvmPackages_10.llvm
        else if (lib.versionOlder old.version "0.34.0" && lib.versionAtLeast old.version "0.33.0") then
          pkgs.llvmPackages_9.llvm
        else if (lib.versionOlder old.version "0.33.0" && lib.versionAtLeast old.version "0.29.0") then
          pkgs.llvmPackages_8.llvm
        else if (lib.versionOlder old.version "0.28.0" && lib.versionAtLeast old.version "0.27.0") then
          pkgs.llvmPackages_7.llvm
        else if (lib.versionOlder old.version "0.27.0" && lib.versionAtLeast old.version "0.23.0") then
          pkgs.llvmPackages_6.llvm
        else if (lib.versionOlder old.version "0.23.0" && lib.versionAtLeast old.version "0.21.0") then
          pkgs.llvmPackages_5.llvm
        else
          pkgs.llvm; # Likely to fail.
    in
    {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.llvm ];

      # Disable static linking
      # https://github.com/numba/llvmlite/issues/93
      postPatch = ''
        substituteInPlace ffi/Makefile.linux --replace "-static-libstdc++" ""

        substituteInPlace llvmlite/tests/test_binding.py --replace "test_linux" "nope"
      '';

      # Set directory containing llvm-config binary
      preConfigure = ''
        export LLVM_CONFIG=${llvm.dev}/bin/llvm-config
      '';

      __impureHostDeps = lib.optionals pkgs.stdenv.isDarwin [ "/usr/lib/libm.dylib" ];

      passthru = old.passthru // { llvm = llvm; };
    }
  );

  lockfile = super.lockfile.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.pbr ];
    }
  );

  lxml = super.lxml.overridePythonAttrs (
    old: {
      nativeBuildInputs = with pkgs; (old.nativeBuildInputs or [ ]) ++ [ pkg-config libxml2.dev libxslt.dev ] ++ lib.optionals stdenv.isDarwin [ xcodebuild ];
      buildInputs = with pkgs; (old.buildInputs or [ ]) ++ [ libxml2 libxslt ];
    }
  );

  markupsafe = super.markupsafe.overridePythonAttrs (
    old: {
      src = old.src.override { pname = builtins.replaceStrings [ "markupsafe" ] [ "MarkupSafe" ] old.pname; };
    }
  );

  matplotlib = super.matplotlib.overridePythonAttrs (
    old:
    let
      enableGhostscript = old.passthru.enableGhostscript or false;
      enableGtk3 = old.passthru.enableTk or false;
      enableQt = old.passthru.enableQt or false;
      enableTk = old.passthru.enableTk or false;

      inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
    in
    {
      NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${pkgs.libcxx}/include/c++/v1";

      XDG_RUNTIME_DIR = "/tmp";

      buildInputs = (old.buildInputs or [ ])
        ++ lib.optional enableGhostscript pkgs.ghostscript
        ++ lib.optional stdenv.isDarwin [ Cocoa ]
        ++ [ self.certifi ];

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs.pkg-config
      ] ++ lib.optional (lib.versionAtLeast super.matplotlib.version "3.5.0") [
        self.setuptools-scm
        self.setuptools-scm-git-archive
      ];

      MPLSETUPCFG = pkgs.writeText "mplsetup.cfg" ''
        [libs]
        system_freetype = True
        system_qhull = True
      '' + lib.optionalString stdenv.isDarwin ''
        # LTO not working in darwin stdenv, see NixOS/nixpkgs/pull/19312
        enable_lto = false
      '';

      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        pkgs.libpng
        pkgs.freetype
        pkgs.qhull
      ]
        ++ lib.optionals enableGtk3 [ pkgs.cairo self.pycairo pkgs.gtk3 pkgs.gobject-introspection self.pygobject3 ]
        ++ lib.optionals enableTk [ pkgs.tcl pkgs.tk self.tkinter pkgs.libX11 ]
        ++ lib.optionals enableQt [ self.pyqt5 ]
      ;

      preBuild = ''
        cp -r ${pkgs.qhull} .
      '';

      inherit (super.matplotlib) patches;
    }
  );

  # Calls Cargo at build time for source builds and is really tricky to package
  maturin = super.maturin.override {
    preferWheel = true;
  };

  mccabe = super.mccabe.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
      doCheck = false;
    }
  );

  mip = super.mip.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.autoPatchelfHook ];

      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.zlib self.cppy ];
    }
  );

  mmdet = super.mmdet.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytorch ];
    }
  );

  molecule =
    if lib.versionOlder super.molecule.version "3.0.0" then
      (super.molecule.overridePythonAttrs (
        old: {
          patches = (old.patches or [ ]) ++ [
            # Fix build with more recent setuptools versions
            (pkgs.fetchpatch {
              url = "https://github.com/ansible-community/molecule/commit/c9fee498646a702c77b5aecf6497cff324acd056.patch";
              sha256 = "1g1n45izdz0a3c9akgxx14zhdw6c3dkb48j8pq64n82fa6ndl1b7";
              excludes = [ "pyproject.toml" ];
            })
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools-scm-git-archive ];
        }
      )) else
      super.molecule.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools-scm-git-archive ];
      });

  mongomock = super.mongomock.overridePythonAttrs (oa: {
    buildInputs = oa.buildInputs ++ [ self.pbr ];
  });

  mpi4py = super.mpi4py.overridePythonAttrs (
    old:
    let
      cfg = pkgs.writeTextFile {
        name = "mpi.cfg";
        text = (
          lib.generators.toINI
            { }
            {
              mpi = {
                mpicc = "${pkgs.mpi.outPath}/bin/mpicc";
              };
            }
        );
      };
    in
    {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.mpi ];
      enableParallelBuilding = true;
      preBuild = ''
        ln -sf ${cfg} mpi.cfg
      '';
    }
  );

  multiaddr = super.multiaddr.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  munch = super.munch.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
    }
  );

  mypy = super.mypy.overridePythonAttrs (
    old: {
      MYPY_USE_MYPYC =
        # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
        stdenv.buildPlatform.is64bit
        # Derivation fails to build since v0.900 if mypyc is enabled.
        && lib.strings.versionOlder old.version "0.900";
    }
  );

  mysqlclient = super.mysqlclient.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.libmysqlclient ];
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libmysqlclient ];
    }
  );

  netcdf4 = super.netcdf4.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.cython
      ];

      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
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

  numpy = super.numpy.overridePythonAttrs (
    old:
    let
      blas = old.passthru.args.blas or pkgs.openblasCompat;
      blasImplementation = lib.nameFromURL blas.name "-";
      cfg = pkgs.writeTextFile {
        name = "site.cfg";
        text = (
          lib.generators.toINI
            { }
            {
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
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.gfortran ];
      buildInputs = (old.buildInputs or [ ]) ++ [ blas self.cython ];
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

  opencv-python = super.opencv-python.overridePythonAttrs (
    old: {
      nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
      buildInputs = [ self.scikit-build ] ++ (old.buildInputs or [ ]);
      dontUseCmakeConfigure = true;
    }
  );

  opencv-contrib-python = super.opencv-contrib-python.overridePythonAttrs (
    old: {
      nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
      buildInputs = [ self.scikit-build ] ++ (old.buildInputs or [ ]);
      dontUseCmakeConfigure = true;
    }
  );

  openexr = super.openexr.overridePythonAttrs (
    old: rec {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openexr pkgs.ilmbase ];
      NIX_CFLAGS_COMPILE = [ "-I${pkgs.openexr.dev}/include/OpenEXR" "-I${pkgs.ilmbase.dev}/include/OpenEXR" ];
    }
  );

  osqp = super.osqp.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.cmake ];
      dontUseCmakeConfigure = true;
    }
  );

  pantalaimon = super.pantalaimon.overridePythonAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.installShellFiles ];
    postInstall = old.postInstall or "" + ''
      installManPage docs/man/*.[1-9]
    '';
  });

  paramiko = super.paramiko.overridePythonAttrs (old: {
    doCheck = false; # requires networking
  });

  parsel = super.parsel.overridePythonAttrs (
    old: rec {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  pdal = super.pdal.overridePythonAttrs (
    old: {
      PDAL_CONFIG = "${pkgs.pdal}/bin/pdal-config";
    }
  );

  peewee = super.peewee.overridePythonAttrs (
    old:
    let
      withPostgres = old.passthru.withPostgres or false;
      withMysql = old.passthru.withMysql or false;
    in
    {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.sqlite ];
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
        ++ lib.optional withPostgres self.psycopg2
        ++ lib.optional withMysql self.mysql-connector;
    }
  );

  pillow = super.pillow.overridePythonAttrs (
    old: {
      nativeBuildInputs = [ pkgs.pkg-config self.pytest-runner ] ++ (old.nativeBuildInputs or [ ]);
      buildInputs = with pkgs; [ freetype libjpeg zlib libtiff libwebp tcl lcms2 ] ++ (old.buildInputs or [ ]);
    }
  );

  platformdirs = super.platformdirs.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py --replace 'setup()' 'setup(version="${old.version}")'
    '';
  });

  poetry-core = super.poetry-core.overridePythonAttrs (old: {
    # "Vendor" dependencies (for build-system support)
    postPatch = ''
      echo "import sys" >> poetry/__init__.py
      for path in $propagatedBuildInputs; do
          echo "sys.path.insert(0, \"$path\")" >> poetry/__init__.py
      done
    '';

    # Propagating dependencies leads to issues downstream
    # We've already patched poetry to prefer "vendored" dependencies
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';
  });

  portend = super.portend.overridePythonAttrs (
    old: {
      # required for the extra "toml" dependency in setuptools_scm[toml]
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.toml
      ];
      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;
    }
  );

  prettytable = super.prettytable.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
  });

  psycopg2 = super.psycopg2.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ])
        ++ lib.optional stdenv.isDarwin pkgs.openssl;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.postgresql ];
    }
  );

  psycopg2-binary = super.psycopg2-binary.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ])
        ++ lib.optional stdenv.isDarwin pkgs.openssl;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.postgresql ];
    }
  );

  pyarrow =
    if lib.versionAtLeast super.pyarrow.version "0.16.0" then
      super.pyarrow.overridePythonAttrs
        (
          old:
          let
            parseMinor = drv: lib.concatStringsSep "." (lib.take 2 (lib.splitVersion drv.version));

            # Starting with nixpkgs revision f149c7030a7, pyarrow takes "python3" as an argument
            # instead of "python". Below we inspect function arguments to maintain compatibilitiy.
            _arrow-cpp = pkgs.arrow-cpp.override (
              builtins.intersectAttrs
                (lib.functionArgs pkgs.arrow-cpp.override)
                { python = self.python; python3 = self.python; }
            );

            ARROW_HOME = _arrow-cpp;
            arrowCppVersion = parseMinor _arrow-cpp;
            pyArrowVersion = parseMinor super.pyarrow;
            errorMessage = "arrow-cpp version (${arrowCppVersion}) mismatches pyarrow version (${pyArrowVersion})";
          in
          if arrowCppVersion != pyArrowVersion then throw errorMessage else {

            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
              self.cython
              pkgs.pkg-config
              pkgs.cmake
            ];

            preBuild = ''
              export PYARROW_PARALLEL=$NIX_BUILD_CORES
            '';

            PARQUET_HOME = _arrow-cpp;
            inherit ARROW_HOME;

            PYARROW_BUILD_TYPE = "release";
            PYARROW_WITH_FLIGHT = if _arrow-cpp.enableFlight then 1 else 0;
            PYARROW_WITH_DATASET = 1;
            PYARROW_WITH_PARQUET = 1;
            PYARROW_CMAKE_OPTIONS = [
              "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib"

              # This doesn't use setup hook to call cmake so we need to workaround #54606
              # ourselves
              "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"
            ];

            dontUseCmakeConfigure = true;
          }
        ) else
      super.pyarrow.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
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
    ).overridePythonAttrs (
      old: {

        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          pkgs.meson
          pkgs.ninja
          pkgs.pkg-config
        ];

        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
          pkgs.cairo
          pkgs.xlibsWrapper
        ];

        mesonFlags = [ "-Dpython=${if self.isPy3k then "python3" else "python"}" ];
      }
    )
  )
    super.pycairo;

  pycocotools = super.pycocotools.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.cython
        self.numpy
      ];
    }
  );

  pyfuse3 = super.pyfuse3.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.fuse3 ];
  });

  pygame = super.pygame.overridePythonAttrs (
    old: rec {
      nativeBuildInputs = [
        pkgs.pkg-config
        pkgs.SDL
      ];

      buildInputs = [
        pkgs.SDL
        pkgs.SDL_image
        pkgs.SDL_mixer
        pkgs.SDL_ttf
        pkgs.libpng
        pkgs.libjpeg
        pkgs.portmidi
        pkgs.xorg.libX11
        pkgs.freetype
      ];

      # Tests fail because of no audio device and display.
      doCheck = false;
      preConfigure = ''
                sed \
                  -e "s/origincdirs = .*/origincdirs = []/" \
                  -e "s/origlibdirs = .*/origlibdirs = []/" \
                  -e "/'\/lib\/i386-linux-gnu', '\/lib\/x86_64-linux-gnu']/d" \
                  -e "/\/include\/smpeg/d" \
                  -i buildconfig/config_unix.py
                ${lib.concatMapStrings
        (dep: ''
                  sed \
                    -e "/origincdirs =/a\        origincdirs += ['${lib.getDev dep}/include']" \
                    -e "/origlibdirs =/a\        origlibdirs += ['${lib.getLib dep}/lib']" \
                    -i buildconfig/config_unix.py
                '')
        buildInputs
                }
                LOCALBASE=/ ${self.python.interpreter} buildconfig/config.py
      '';
    }
  );

  pygeos = super.pygeos.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.geos ];
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.geos ];
    }
  );

  pygobject = super.pygobject.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.glib pkgs.gobject-introspection ];
    }
  );

  pylint = super.pylint.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  pyopenssl = super.pyopenssl.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl ];
    }
  );

  pyproj = super.pyproj.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++
        [ self.cython ];
      PROJ_DIR = "${pkgs.proj}";
      PROJ_LIBDIR = "${pkgs.proj}/lib";
      PROJ_INCDIR = "${pkgs.proj.dev}/include";
    }
  );

  pyproject-flake8 = super.pyproject-flake8.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.flit-core ];
    }
  );

  pytaglib = super.pytaglib.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.taglib ];
  });

  pytezos = super.pytezos.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libsodium ];
  });

  python-bugzilla = super.python-bugzilla.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        self.docutils
      ];
    }
  );

  python-ldap = super.python-ldap.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openldap pkgs.cyrus_sasl ];
    }
  );

  pytoml = super.pytoml.overridePythonAttrs (
    old: {
      doCheck = false;
    }
  );

  pyqt5 =
    let
      drv = super.pyqt5;
      withConnectivity = drv.passthru.args.withConnectivity or false;
      withMultimedia = drv.passthru.args.withMultimedia or false;
      withWebKit = drv.passthru.args.withWebKit or false;
      withWebSockets = drv.passthru.args.withWebSockets or false;
    in
    super.pyqt5.overridePythonAttrs (
      old: {
        format = "other";

        dontWrapQtApps = true;

        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          pkgs.pkg-config
          pkgs.qt5.qmake
          pkgs.xorg.lndir
          pkgs.qt5.qtbase
          pkgs.qt5.qtsvg
          pkgs.qt5.qtdeclarative
          pkgs.qt5.qtwebchannel
          pkgs.qt5.qt3d
          # self.pyqt5-sip
          self.sip
        ]
          ++ lib.optional withConnectivity pkgs.qt5.qtconnectivity
          ++ lib.optional withMultimedia pkgs.qt5.qtmultimedia
          ++ lib.optional withWebKit pkgs.qt5.qtwebkit
          ++ lib.optional withWebSockets pkgs.qt5.qtwebsockets
        ;

        buildInputs = (old.buildInputs or [ ]) ++ [
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
        patches = pkgs.python3.pkgs.pyqt5.patches or [ ];

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

        installCheckPhase =
          let
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

  pytest-datadir = super.pytest-datadir.overridePythonAttrs (
    old: {
      postInstall = ''
        rm -f $out/LICENSE
      '';
    }
  );

  pytest = super.pytest.overridePythonAttrs (
    old: {
      # Fixes https://github.com/pytest-dev/pytest/issues/7891
      postPatch = old.postPatch or "" + ''
        sed -i '/\[metadata\]/aversion = ${old.version}' setup.cfg
      '';
    }
  );

  pytest-django = super.pytest-django.overridePythonAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace "'pytest>=3.6'," ""
        substituteInPlace setup.py --replace "'pytest>=3.6'" ""
      '';
    }
  );

  pytest-randomly = super.pytest-randomly.overrideAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      self.importlib-metadata
    ];
  });

  pytest-runner = super.pytest-runner or super.pytestrunner;

  pytest-pylint = super.pytest-pylint.overridePythonAttrs (
    old: {
      buildInputs = [ self.pytest-runner ];
    }
  );

  # pytest-splinter seems to put a .marker file in an empty directory
  # presumably so it's tracked by and can be installed with MANIFEST.in, see
  # https://github.com/pytest-dev/pytest-splinter/commit/a48eeef662f66ff9d3772af618748e73211a186b
  #
  # This directory then gets used as an empty initial profile directory and is
  # zipped up. But if the .marker file is in the Nix store, it has the
  # creation date of 1970, and Zip doesn't work with such old files, so it
  # fails at runtime!
  #
  # We fix this here by just removing the file after the installation
  #
  # The error you get without this is:
  #
  # E           ValueError: ZIP does not support timestamps before 1980
  # /nix/store/55b9ip7xkpimaccw9pa0vacy5q94f5xa-python3-3.7.6/lib/python3.7/zipfile.py:357: ValueError
  pytest-splinter = super.pytest-splinter.overrideAttrs (old: {
    postInstall = old.postInstall or "" + ''
      rm $out/${super.python.sitePackages}/pytest_splinter/profiles/firefox/.marker
    '';
  });

  python-jose = super.python-jose.overridePythonAttrs (
    old: {
      buildInputs = [ self.pytest-runner ];
    }
  );

  python-olm = super.python-olm.overridePythonAttrs (
    old: {
      buildInputs = old.buildInputs or [ ] ++ [ pkgs.olm ];
    }
  );

  python-snappy = super.python-snappy.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.snappy ];
    }
  );

  pythran = super.pythran.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
  });

  ffmpeg-python = super.ffmpeg-python.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  python-prctl = super.python-prctl.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs.libcap
      ];
    }
  );

  pyudev = super.pyudev.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace src/pyudev/_ctypeslib/utils.py \
        --replace "find_library(name)" "'${pkgs.lib.getLib pkgs.systemd}/lib/libudev.so'"
    '';
  });

  pyusb = super.pyusb.overridePythonAttrs (
    old: {
      postPatch = ''
        libusb=${pkgs.libusb1.out}/lib/libusb-1.0${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}
        test -f $libusb || { echo "ERROR: $libusb doesn't exist, please update/fix this build expression."; exit 1; }
        sed -i -e "s|find_library=None|find_library=lambda _:\"$libusb\"|" usb/backend/libusb1.py
      '';
    }
  );

  pywavelets = super.pywavelets.overridePythonAttrs (
    old: {
      HDF5_DIR = "${pkgs.hdf5}";
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.hdf5 ];
    }
  );

  pyzmq = super.pyzmq.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.zeromq ];
    }
  );

  rockset = super.rockset.overridePythonAttrs (
    old: rec {
      postPatch = ''
        cp ./setup_rockset.py ./setup.py
      '';
    }
  );

  scaleapi = super.scaleapi.overridePythonAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.py --replace "install_requires = ['requests>=2.4.2', 'enum34']" "install_requires = ['requests>=2.4.2']" || true
      '';
    }
  );

  pandas = super.pandas.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.cython ];
    }
  );

  panel = super.panel.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.nodejs ];
    }
  );

  # Pybind11 is an undeclared dependency of scipy that we need to pick from nixpkgs
  # Make it not fail with infinite recursion
  pybind11 = super.pybind11.overridePythonAttrs (
    old: {
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        "-DPYBIND11_TEST=off"
      ];
      doCheck = false; # Circular test dependency
    }
  );

  requests-mock = super.requests-mock.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ super.pbr ];
    }
  );

  requests-unixsocket = super.requests-unixsocket.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pbr ];
    }
  );

  requestsexceptions = super.requestsexceptions.overridePythonAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ self.pbr ];
  });

  rlp = super.rlp.overridePythonAttrs {
    preConfigure = ''
      substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    '';
  };


  rmfuse = super.rmfuse.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
  });

  rtree = super.rtree.overridePythonAttrs (old: {
    propagatedNativeBuildInputs = (old.propagatedNativeBuildInputs or [ ]) ++ [ pkgs.libspatialindex ];
    postPatch = ''
      substituteInPlace rtree/finder.py --replace \
        "find_library('spatialindex_c')" \
        "'${pkgs.libspatialindex}/lib/libspatialindex_c${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}'"
    '';
  });

  ruamel-yaml = super.ruamel-yaml.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
        ++ [ self.ruamel-yaml-clib ];
    }
  );

  scipy = super.scipy.overridePythonAttrs (
    old:
    if old.format != "wheel" then {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++
        [ pkgs.gfortran ] ++
        lib.optional (lib.versionAtLeast super.scipy.version "1.7.0") [ self.cython self.pythran ];
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.pybind11 ];
      setupPyBuildFlags = [ "--fcompiler='gnu95'" ];
      enableParallelBuilding = true;
      buildInputs = (old.buildInputs or [ ]) ++ [ self.numpy.blas ];
      preConfigure = ''
        sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
        export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
      '';
      preBuild = ''
        ln -s ${self.numpy.cfg} site.cfg
      '';
    } else old
  );

  scikit-image = super.scikit-image.overridePythonAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        self.cython
        self.pythran
        self.packaging
        self.wheel
        self.numpy
      ];
    }
  );

  scikit-learn = super.scikit-learn.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs.gfortran
        pkgs.glibcLocales
      ] ++ lib.optionals stdenv.cc.isClang [
        pkgs.llvmPackages.openmp
      ];

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        self.cython
      ];

      enableParallelBuilding = true;
    }
  );

  secp256k1 = super.secp256k1.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkgconfig pkgs.autoconf pkgs.automake pkgs.libtool ];
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    doCheck = false;
    # Local setuptools versions like "x.y.post0" confuse an internal check
    postPatch = ''
      substituteInPlace setup.py \
        --replace 'setuptools_version.' '"${self.setuptools.version}".'
    '';
  });

  shapely = super.shapely.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.geos self.cython ];
      inherit (pkgs.python3.pkgs.shapely) patches GEOS_LIBRARY_PATH;
    }
  );

  shellcheck-py = super.shellcheck-py.overridePythonAttrs (old: {

    # Make fetching/installing external binaries no-ops
    preConfigure =
      let
        fakeCommand = "type('FakeCommand', (Command,), {'initialize_options': lambda self: None, 'finalize_options': lambda self: None, 'run': lambda self: None})";
      in
      ''
        substituteInPlace setup.py \
          --replace "'fetch_binaries': fetch_binaries," "'fetch_binaries': ${fakeCommand}," \
          --replace "'install_shellcheck': install_shellcheck," "'install_shellcheck': ${fakeCommand},"
      '';

    propagatedUserEnvPkgs = (old.propagatedUserEnvPkgs or [ ]) ++ [
      pkgs.shellcheck
    ];

  });

  tables = super.tables.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pywavelets ];
      HDF5_DIR = lib.getDev pkgs.hdf5;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
      propagatedBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.hdf5 self.numpy self.numexpr ];
    }
  );

  tempora = super.tempora.overridePythonAttrs (
    old: {
      # required for the extra "toml" dependency in setuptools_scm[toml]
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.toml
      ];
      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;
    }
  );

  tensorboard = super.tensorboard.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.wheel
        self.absl-py
      ];
      HDF5_DIR = "${pkgs.hdf5}";
      propagatedBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs.hdf5
        self.google-auth-oauthlib
        self.tensorboard-plugin-wit
        self.numpy
        self.markdown
        self.tensorboard-data-server
        self.grpcio
        self.protobuf
        self.werkzeug
        self.absl-py
      ];
    }
  );

  tensorflow = super.tensorflow.overridePythonAttrs (
    old: {
      postInstall = ''
        rm $out/bin/tensorboard
      '';
    }
  );

  tensorpack = super.tensorpack.overridePythonAttrs (
    old: {
      postPatch = ''
        substituteInPlace setup.cfg --replace "# will call find_packages()" ""
      '';
    }
  );

  tinycss2 = super.tinycss2.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  # The tokenizers build requires a complex rust setup (cf. nixpkgs override)
  #
  # Instead of providing a full source build, we use a wheel to keep
  # the complexity manageable for now.
  tokenizers = super.tokenizers.override {
    preferWheel = true;
  };

  torch = lib.makeOverridable
    ({ enableCuda ? false
     , cudatoolkit ? pkgs.cudatoolkit_10_1
     , pkg ? super.torch
     }: pkg.overrideAttrs (old:
      {
        preConfigure =
          if (!enableCuda) then ''
            export USE_CUDA=0
          '' else ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${cudatoolkit}/targets/x86_64-linux/lib"
          '';
        preFixup = lib.optionalString (!enableCuda) ''
          # For some reason pytorch retains a reference to libcuda even if it
          # is explicitly disabled with USE_CUDA=0.
          find $out -name "*.so" -exec ${pkgs.patchelf}/bin/patchelf --remove-needed libcuda.so.1 {} \;
        '';
        buildInputs =
          (old.buildInputs or [ ])
          ++ [ self.typing-extensions ]
          ++ lib.optionals enableCuda [
            pkgs.linuxPackages.nvidia_x11
            pkgs.nccl.dev
            pkgs.nccl.out
          ];
        propagatedBuildInputs = [
          self.numpy
          self.future
          self.typing-extensions
        ];
      })
    )
    { };

  torchvision = lib.makeOverridable
    ({ enableCuda ? false
     , cudatoolkit ? pkgs.cudatoolkit_10_1
     , pkg ? super.torchvision
     }: pkg.overrideAttrs (old: {

      # without that autoPatchelfHook will fail because cudatoolkit is not in LD_LIBRARY_PATH
      autoPatchelfIgnoreMissingDeps = true;
      buildInputs = (old.buildInputs or [ ])
        ++ [ self.torch ]
        ++ lib.optionals enableCuda [
        cudatoolkit
      ];
      preConfigure =
        if (enableCuda) then ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${self.torch}/${self.python.sitePackages}/torch/lib:${lib.makeLibraryPath [ cudatoolkit "${cudatoolkit}" ]}"
        '' else ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${self.torch}/${self.python.sitePackages}/torch/lib"
        '';
    }))
    { };

  typeguard = super.typeguard.overridePythonAttrs (old: {
    postPatch = ''
      substituteInPlace setup.py \
        --replace 'setup()' 'setup(version="${old.version}")'
    '';
  });

  typed_ast = super.typed-ast.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      self.pytest-runner
    ];
  });

  # nix uses a dash, poetry uses an underscore
  typing-extensions = (super.typing_extensions or super.typing-extensions).overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++
        lib.optional (lib.versionAtLeast old.version "4.0.0") [ self.flit-core ];
    }
  );

  urwidtrees = super.urwidtrees.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        self.urwid
      ];
    }
  );

  vose-alias-method = super.vose-alias-method.overridePythonAttrs (
    old: {
      postInstall = ''
        rm -f $out/LICENSE
      '';
    }
  );

  vispy = super.vispy.overrideAttrs (
    old: {
      inherit (pkgs.python3.pkgs.vispy) patches;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        self.cython
        self.setuptools-scm-git-archive
      ];
    }
  );

  uvloop = super.uvloop.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ lib.optionals stdenv.isDarwin [
        pkgs.darwin.apple_sdk.frameworks.ApplicationServices
        pkgs.darwin.apple_sdk.frameworks.CoreServices
      ];
    }
  );


  # Stop infinite recursion by using bootstrapped pkg from nixpkgs
  bootstrapped-pip = super.bootstrapped-pip.override {
    wheel = (pkgs.python3.pkgs.override {
      python = self.python;
    }).wheel;
  };

  weasyprint = super.weasyprint.overridePythonAttrs (
    old: {
      inherit (pkgs.python3.pkgs.weasyprint) patches;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  web3 = super.web3.overridePythonAttrs {
    preConfigure = ''
      substituteInPlace setup.py --replace \'setuptools-markdown\' ""
    '';
  };

  weblate-language-data = super.weblate-language-data.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [
        self.translate-toolkit
      ];
    }
  );

  wheel =
    let
      isWheel = super.wheel.src.isWheel or false;
      # If "wheel" is a pre-built binary wheel
      wheelPackage = super.buildPythonPackage {
        inherit (super.wheel) pname name version src;
        inherit (pkgs.python3.pkgs.wheel) meta;
        format = "wheel";
      };
      # If "wheel" is built from source
      sourcePackage = ((
        pkgs.python3.pkgs.override {
          python = self.python;
        }
      ).wheel.override {
        inherit (self) buildPythonPackage bootstrapped-pip setuptools;
      }).overrideAttrs (old: {
        inherit (super.wheel) pname name version src;
      });
    in
    if isWheel then wheelPackage else sourcePackage;

  zipp = if super.zipp == null then null else
  (
    if lib.versionAtLeast super.zipp.version "2.0.0" then
      (
        super.zipp.overridePythonAttrs (
          old:
          if (old.format or "pyproject") != "wheel" then {
            prePatch = ''
              substituteInPlace setup.py --replace \
              'setuptools.setup()' \
              'setuptools.setup(version="${super.zipp.version}")'
            '';
          } else old
        )
      ) else super.zipp
  ).overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        self.toml
      ];
    }
  );

  credis = super.credis.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.cython ];
    }
  );

  hashids = super.hashids.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.flit-core ];
    }
  );

  packaging = super.packaging.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++
        # From 20.5 until 20.7, packaging used flit for packaging (heh)
        # See https://github.com/pypa/packaging/pull/352 and https://github.com/pypa/packaging/pull/367
        lib.optional (lib.versionAtLeast old.version "20.5" && lib.versionOlder old.version "20.8") [ self.flit-core ];
    }
  );

  psutil = super.psutil.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++
        lib.optional stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.IOKit;
    }
  );

  sentencepiece = super.sentencepiece.overridePythonAttrs (
    old: {
      dontUseCmakeConfigure = true;
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs.pkg-config
        pkgs.cmake
        pkgs.gperftools
      ];
      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs.sentencepiece
      ];
    }
  );

  sentence-transformers = super.sentence-transformers.overridePythonAttrs (
    old: {
      buildInputs =
        (old.buildInputs or [ ])
        ++ [ self.typing-extensions ];
    }
  );

  supervisor = super.supervisor.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
        self.meld3
        self.setuptools
      ];
    }
  );

  cytoolz = super.cytoolz.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.toolz ];
    }
  );

  # For some reason the toml dependency of tqdm declared here:
  # https://github.com/tqdm/tqdm/blob/67130a23646ae672836b971e1086b6ae4c77d930/pyproject.toml#L2
  # is not translated correctly to a nix dependency.
  tqdm = super.tqdm.overrideAttrs (
    old: {
      buildInputs = [ super.toml ] ++ (old.buildInputs or [ ]);
    }
  );

  watchdog = super.watchdog.overrideAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ])
        ++ pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.CoreServices;
    }
  );

  # pyee cannot find `vcversioner` and other "setup requirements", so it tries to
  # download them from the internet, which only works when nix sandboxing is disabled.
  # Additionally, since pyee uses vcversioner to specify its version, we need to do this
  # manually specify its version.
  pyee = super.pyee.overrideAttrs (
    old: {
      postPatch = old.postPatch or "" + ''
        sed -i setup.py \
          -e '/setup_requires/,/],/d' \
          -e 's/vcversioner={},/version="${old.version}",/'
      '';
    }
  );

  # nixpkgs has setuptools_scm 4.1.2
  # but newrelic has a seemingly unnecessary version constraint for <4
  # So we patch that out
  newrelic = super.newrelic.overridePythonAttrs (
    old: {
      postPatch = old.postPatch or "" + ''
        substituteInPlace setup.py --replace '"setuptools_scm>=3.2,<4"' '"setuptools_scm"'
      '';
    }
  );

  wxpython = super.wxpython.overridePythonAttrs (old:
    let
      localPython = self.python.withPackages (ps: with ps; [
        setuptools
        numpy
        six
      ]);
    in
    {
      DOXYGEN = "${pkgs.doxygen}/bin/doxygen";

      nativeBuildInputs = with pkgs; [
        which
        doxygen
        gtk3
        pkg-config
        autoPatchelfHook
      ] ++ (old.nativeBuildInputs or [ ]);

      buildInputs = with pkgs; [
        gtk3
        webkitgtk
        ncurses
        SDL2
        xorg.libXinerama
        xorg.libSM
        xorg.libXxf86vm
        xorg.libXtst
        xorg.xorgproto
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        libGLU
        libGL
        libglvnd
        mesa
      ] ++ old.buildInputs;

      buildPhase = ''
        ${localPython.interpreter} build.py -v build_wx
        ${localPython.interpreter} build.py -v dox etg --nodoc sip
        ${localPython.interpreter} build.py -v build_py
      '';

      installPhase = ''
        ${localPython.interpreter} setup.py install --skip-build --prefix=$out
      '';
    });

  marisa-trie = super.marisa-trie.overridePythonAttrs (
    old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
    }
  );

  ua-parser = super.ua-parser.overridePythonAttrs (
    old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.pyyaml ];
    }
  );

  lazy-object-proxy = super.lazy-object-proxy.overridePythonAttrs (
    old: {
      # disable the removal of pyproject.toml, required because of setuptools_scm
      dontPreferSetupPy = true;
    }
  );

  pendulum = super.pendulum.overridePythonAttrs (old: {
    # Technically incorrect, but fixes the build error..
    preInstall = lib.optionalString stdenv.isLinux ''
      mv --no-clobber ./dist/*.whl $(echo ./dist/*.whl | sed s/'manylinux_[0-9]*_[0-9]*'/'manylinux1'/)
    '';
  });

  pygraphviz = super.pygraphviz.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.graphviz ];
  });

  pyjsg = super.pyjsg.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
  });

  pyshex = super.pyshex.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
  });

  pyshexc = super.pyshexc.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
  });

  pysqlite = super.pysqlite.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.sqlite ];
  });

  selinux = super.selinux.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools-scm-git-archive ];
  });

  shexjsg = super.shexjsg.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
  });

  sparqlslurper = super.sparqlslurper.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.pbr ];
  });

  tomli = super.tomli.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.flit-core ];
  });

  uwsgi = super.uwsgi.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.ncurses ];
    sourceRoot = ".";
  });

  wcwidth = super.wcwidth.overridePythonAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++
      lib.optional self.isPy27 (self.backports-functools-lru-cache or self.backports_functools_lru_cache)
    ;
  });

  wtforms = super.wtforms.overridePythonAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ self.Babel ];
  });
}
