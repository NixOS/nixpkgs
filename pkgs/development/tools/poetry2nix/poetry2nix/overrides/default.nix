{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
}:

let
  addBuildSystem =
    { self
    , drv
    , attr
    , extraAttrs ? [ ]
    }:
    let
      buildSystem =
        if builtins.isAttrs attr then
          let
            fromIsValid =
              if builtins.hasAttr "from" attr then
                lib.versionAtLeast drv.version attr.from
              else
                true;
            untilIsValid =
              if builtins.hasAttr "until" attr then
                lib.versionOlder drv.version attr.until
              else
                true;
            intendedBuildSystem =
              if attr.buildSystem == "cython" then
                self.python.pythonForBuild.pkgs.cython
              else
                self.${attr.buildSystem};
          in
          if fromIsValid && untilIsValid then intendedBuildSystem else null
        else
          if attr == "cython" then self.python.pythonForBuild.pkgs.cython else self.${attr};
    in
    (
      # Flit only works on Python3
      if (attr == "flit-core" || attr == "flit" || attr == "hatchling") && !self.isPy3k then drv
      else if drv == null then null
      else if drv ? overridePythonAttrs == false then drv
      else
        drv.overridePythonAttrs (
          old:
          # We do not need the build system for wheels.
          if old ? format && old.format == "wheel" then
            { }
          else
            {
              nativeBuildInputs =
                (old.nativeBuildInputs or [ ])
                ++ lib.optionals (!(builtins.isNull buildSystem)) [ buildSystem ]
                ++ map (a: self.${a}) extraAttrs;
            }
        )
    );


in
lib.composeManyExtensions [
  # NixOps
  (self: super:
    lib.mapAttrs (_: v: addBuildSystem { inherit self; drv = v; attr = "poetry"; }) (lib.filterAttrs (n: _: lib.strings.hasPrefix "nixops" n) super)
    // {
      # NixOps >=2 dependency
      nixos-modules-contrib = addBuildSystem { inherit self; drv = super.nixos-modules-contrib; attr = "poetry"; };
    }
  )

  # Add build systems
  (self: super:
    let
      buildSystems = lib.importJSON ./build-systems.json;
    in
    lib.mapAttrs
      (attr: systems: builtins.foldl'
        (drv: attr: addBuildSystem {
          inherit drv self attr;
        })
        (super.${attr} or null)
        systems)
      buildSystems)

  # Build fixes
  (self: super:
    let
      inherit (self.python) stdenv;
      inherit (pkgs.buildPackages) pkg-config;
      pyBuildPackages = self.python.pythonForBuild.pkgs;

      selectQt5 = version:
        let
          selector = builtins.concatStringsSep "" (lib.take 2 (builtins.splitVersion version));
        in
          pkgs."qt${selector}" or pkgs.qt5;

    in

    {
      automat = super.automat.overridePythonAttrs (
        old: lib.optionalAttrs (lib.versionOlder old.version "22.10.0") {
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
        }
      );

      ansible-base = super.ansible-base.overridePythonAttrs (
        old:
        {
          prePatch = ''sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py'';
          postInstall = ''
            for m in docs/man/man1/*; do
                install -vD $m -t $out/share/man/man1
            done
          '';
        }
        // lib.optionalAttrs (lib.versionOlder old.version "2.4") {
          prePatch = ''sed -i "s,/usr/,$out," lib/ansible/constants.py'';
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

      argcomplete = super.argcomplete.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.importlib-metadata ];
        }
      );

      arpeggio = super.arpeggio.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.pytest-runner ];
        }
      );

      astroid = super.astroid.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
        }
      );

      av = super.av.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkg-config
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.ffmpeg_4 ];
        }
      );

      argon2-cffi =
        if (lib.versionAtLeast super.argon2-cffi.version "21.2.0") then
          addBuildSystem
            {
              inherit self;
              drv = super.argon2-cffi;
              attr = "flit-core";
            } else super.argon2-cffi;

      awscrt = super.awscrt.overridePythonAttrs (
        old: {
          nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
          dontUseCmakeConfigure = true;
        }
      );
      bcrypt =
        let
          getCargoHash = version: {
            "4.0.0" = "sha256-HvfRLyUhlXVuvxWrtSDKx3rMKJbjvuiMcDY6g+pYFS0=";
            "4.0.1" = "sha256-lDWX69YENZFMu7pyBmavUZaalGvFqbHSHfkwkzmDQaY=";
          }.${version} or (
            lib.warn "Unknown bcrypt version: '${version}'. Please update getCargoHash." lib.fakeHash
          );
        in
        super.bcrypt.overridePythonAttrs (
          old: {
            buildInputs = (old.buildInputs or [ ])
              ++ [ pkgs.libffi ]
              ++ lib.optionals (lib.versionAtLeast old.version "4" && stdenv.isDarwin)
              [ pkgs.darwin.apple_sdk.frameworks.Security pkgs.libiconv ];
            nativeBuildInputs = with pkgs;
              (old.nativeBuildInputs or [ ])
                ++ lib.optionals (lib.versionAtLeast old.version "4") [ rustc cargo pkgs.rustPlatform.cargoSetupHook self.setuptools-rust ];
          } // lib.optionalAttrs (lib.versionAtLeast old.version "4") {
            cargoDeps =
              pkgs.rustPlatform.fetchCargoTarball
                {
                  src = old.src;
                  sourceRoot = "${old.pname}-${old.version}/src/_bcrypt";
                  name = "${old.pname}-${old.version}";
                  sha256 = getCargoHash old.version;
                };
            cargoRoot = "src/_bcrypt";
          }
        );
      bjoern = super.bjoern.overridePythonAttrs (
        old: {
          buildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.libev ];
        }
      );

      borgbackup = super.borgbackup.overridePythonAttrs (
        old: {
          BORG_OPENSSL_PREFIX = pkgs.openssl.dev;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
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

      cattrs =
        let
          drv = super.cattrs;
        in
        if drv.version == "1.10.0" then
          drv.overridePythonAttrs
            (old: {
              # 1.10.0 contains a pyproject.toml that requires a pre-release Poetry
              # We can avoid using Poetry and use the generated setup.py
              preConfigure = old.preConfigure or "" + ''
                rm pyproject.toml
              '';
            }) else drv;

      ccxt = super.ccxt.overridePythonAttrs (old: {
        preBuild = ''
          ln -s README.{rst,md}
        '';
      });

      celery = super.celery.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
      });

      cerberus = super.cerberus.overridePythonAttrs (old: {
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
              nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkg-config ];
              buildInputs = old.buildInputs or [ ] ++ [ pkgs.libffi ];
              prePatch = (old.prePatch or "") + lib.optionalString (!(old.src.isWheel or false) && stdenv.isDarwin) ''
                # Remove setup.py impurities
                substituteInPlace setup.py --replace "'-iwithsysroot/usr/include/ffi'" ""
                substituteInPlace setup.py --replace "'/usr/include/ffi'," ""
                substituteInPlace setup.py --replace '/usr/include/libffi' '${lib.getDev pkgs.libffi}/include'
              '';

            }
          )
        );

      cmdstanpy = super.cmdstanpy.overridePythonAttrs (
        old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.cmdstan ];
          patchPhase = ''
            substituteInPlace cmdstanpy/model.py \
              --replace 'cmd = [make]' \
              'cmd = ["${pkgs.cmdstan}/bin/stan"]'
          '';
          CMDSTAN = "${pkgs.cmdstan}";
        }
      );

      contourpy = super.contourpy.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pybind11 ];
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

      coincurve = super.coincurve.overridePythonAttrs (
        old: {
          # package setup logic
          LIB_DIR = "${lib.getLib pkgs.secp256k1}/lib";

          # for actual C toolchain build
          NIX_CFLAGS_COMPILE = "-I ${lib.getDev pkgs.secp256k1}/include";
          NIX_LDFLAGS = "-L ${lib.getLib pkgs.secp256k1}/lib";
        }
      );

      configparser = super.configparser.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [
            self.toml
          ];
        }
      );

      confluent-kafka = super.confluent-kafka.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [
            pkgs.rdkafka
          ];
        }
      );

      copier = super.copier.overrideAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.git ];
      });

      cryptography =
        let
          getCargoHash = version: {
            "35.0.0" = "sha256-tQoQfo+TAoqAea86YFxyj/LNQCiViu5ij/3wj7ZnYLI=";
            "36.0.0" = "sha256-Y6TuW7AryVgSvZ6G8WNoDIvi+0tvx8ZlEYF5qB0jfNk=";
            "36.0.1" = "sha256-kozYXkqt1Wpqyo9GYCwN08J+zV92ZWFJY/f+rulxmeQ=";
            "36.0.2" = "1a0ni1a3dbv2dvh6gx2i54z8v5j9m6asqg97kkv7gqb1ivihsbp8";
            "37.0.2" = "sha256-qvrxvneoBXjP96AnUPyrtfmCnZo+IriHR5HbtWQ5Gk8=";
            "37.0.4" = "sha256-f8r6QclTwkgK20CNe9i65ZOqvSUeDc4Emv6BFBhh1hI";
            "38.0.1" = "sha256-o8l13fnfEUvUdDasq3LxSPArozRHKVsZfQg9DNR6M6Q=";
            "38.0.3" = "sha256-lzHLW1N4hZj+nn08NZiPVM/X+SEcIsuZDjEOy0OOkSc=";
            "38.0.4" = "sha256-BN0kOblUwgHj5QBf52RY2Jx0nBn03lwoN1O5PEohbwY=";
            "39.0.0" = "sha256-clorC0NtGukpE3DnZ84MSdGhJN+qC89DZPITZFuL01Q=";
            "39.0.2" = "sha256-Admz48/GS2t8diz611Ciin1HKQEyMDEwHxTpJ5tZ1ZA=";
            "40.0.0" = "sha256-/TBANavYria9YrBpMgjtFyqg5feBcloETcYJ8fdBgkI=";
            "40.0.1" = "sha256-gFfDTc2QWBWHBCycVH1dYlCsWQMVcRZfOBIau+njtDU=";
            "40.0.2" = "sha256-cV4GTfbVYanElXOVmynvrru2wJuWvnT1Z1tQKXdkbg0=";
            "41.0.1" = "sha256-38q81vRf8QHR8lFRM2KbH7Ng5nY7nmtWRMoPWS9VO/U=";
          }.${version} or (
            lib.warn "Unknown cryptography version: '${version}'. Please update getCargoHash." lib.fakeHash
          );
          sha256 = getCargoHash super.cryptography.version;
          isWheel = lib.hasSuffix ".whl" super.cryptography.src;
          scrypto =
            if isWheel then
              (
                super.cryptography.overridePythonAttrs { preferWheel = true; }
              ) else super.cryptography;
        in
        scrypto.overridePythonAttrs
          (
            old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ])
                ++ lib.optionals (lib.versionAtLeast old.version "3.4") [ self.setuptools-rust ]
                ++ lib.optional (!self.isPyPy) pyBuildPackages.cffi
                ++ lib.optional (lib.versionAtLeast old.version "3.5" && !isWheel) [ pkgs.rustPlatform.cargoSetupHook pkgs.cargo pkgs.rustc ]
                ++ [ pkg-config ]
              ;
              buildInputs = (old.buildInputs or [ ])
                ++ [ pkgs.libxcrypt ]
                ++ [ (if lib.versionAtLeast old.version "37" then pkgs.openssl_3 else pkgs.openssl_1_1) ]
                ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security pkgs.libiconv ];
              propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [ self.cffi ];
            } // lib.optionalAttrs (lib.versionAtLeast old.version "3.4" && lib.versionOlder old.version "3.5") {
              CRYPTOGRAPHY_DONT_BUILD_RUST = "1";
            } // lib.optionalAttrs (lib.versionAtLeast old.version "3.5" && !isWheel) rec {
              cargoDeps =
                pkgs.rustPlatform.fetchCargoTarball {
                  src = old.src;
                  sourceRoot = "${old.pname}-${old.version}/${cargoRoot}";
                  name = "${old.pname}-${old.version}";
                  inherit sha256;
                };
              cargoRoot = "src/rust";
            }
          );

      cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
        postPatch = ''
          substituteInPlace setup.py --replace 'setuptools>=50.3.2,<51.0.0' 'setuptools'
        '';
      });

      cysystemd = super.cysystemd.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.systemd ];
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
      });

      daphne = super.daphne.overridePythonAttrs (old: {
        postPatch = ''
          substituteInPlace setup.py --replace 'setup_requires=["pytest-runner"],' ""
        '';
      });

      darts = super.darts.override {
        preferWheel = true;
      };

      datadog-lambda = super.datadog-lambda.overridePythonAttrs (old: {
        postPatch = ''
          substituteInPlace setup.py --replace "setuptools==" "setuptools>="
        '';
        buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];
      });

      databricks-connect = super.databricks-connect.overridePythonAttrs (old: {
        sourceRoot = ".";
      });

      dbt-extractor = super.dbt-extractor.overridePythonAttrs
        (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.cargo pkgs.rustc pkgs.maturin ];
          }
        );

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

        nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkg-config ];
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
          (lib.optionals pkgs.stdenv.isDarwin [ pkgs.darwin.IOKit ]);
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

      # Setuptools >= 60 broke build_py_2to3
      docutils =
        if lib.versionOlder super.docutils.version "0.16" && lib.versionAtLeast super.setuptools.version "60" then
          (
            super.docutils.overridePythonAttrs (
              old: {
                SETUPTOOLS_USE_DISTUTILS = "stdlib";
              }
            )
          ) else super.docutils;

      duckdb = super.duckdb.overridePythonAttrs (old: {
        postPatch = lib.optionalString (!(old.src.isWheel or false)) ''
          cd tools/pythonpkg

          substituteInPlace setup.py \
            --replace 'multiprocessing.cpu_count()' "$NIX_BUILD_CORES" \
            --replace 'setuptools_scm<7.0.0' 'setuptools_scm'
        '';
      });

      # Environment markers are not always included (depending on how a dep was defined)
      enum34 = if self.pythonAtLeast "3.4" then null else super.enum34;

      eth-hash = super.eth-hash.overridePythonAttrs {
        preConfigure = ''
          substituteInPlace setup.py --replace \'setuptools-markdown\' ""
        '';
      };

      eth-keyfile = super.eth-keyfile.overridePythonAttrs (old: {
        preConfigure = ''
          substituteInPlace setup.py --replace \'setuptools-markdown\' ""
        '';

        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
      });

      eth-keys = super.eth-keys.overridePythonAttrs {
        preConfigure = ''
          substituteInPlace setup.py --replace \'setuptools-markdown\' ""
        '';
      };

      # FIXME: this is a workaround for https://github.com/nix-community/poetry2nix/issues/1161
      eth-utils = super.eth-utils.override { preferWheel = true; };

      evdev = super.evdev.overridePythonAttrs (old: {
        preConfigure = ''
          substituteInPlace setup.py --replace /usr/include/linux ${pkgs.linuxHeaders}/include/linux
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
          postPatch = lib.optionalString (!(old.src.isWheel or false)) ''
            substituteInPlace setup.py \
              --replace 'setup_requires="setupmeta"' 'setup_requires=[]' \
              --replace 'versioning="devcommit"' 'version="${old.version}"'
          '';
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

      file-magic = super.file-magic.overridePythonAttrs (
        old: {
          postPatch = ''
            substituteInPlace magic.py --replace "find_library('magic')" "'${pkgs.file}/lib/libmagic${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}'"
          '';
        }
      );

      fiona = super.fiona.overridePythonAttrs (
        old: {
          format = lib.optionalString (!(old.src.isWheel or false)) "setuptools";
          buildInputs = old.buildInputs or [ ] ++ [ pkgs.gdal ];
          nativeBuildInputs = old.nativeBuildInputs or [ ]
            ++ lib.optionals ((old.src.isWheel or false) && (!pkgs.stdenv.isDarwin)) [ pkgs.autoPatchelfHook ]
            # for gdal-config
            ++ [ pkgs.gdal ];
        }
      );

      flatbuffers = super.flatbuffers.overrideAttrs (old: {
        VERSION = old.version;
      });

      gdal =
        let
          # Build gdal without python bindings to prevent version mixing
          # We're only interested in the native libraries, not the python ones
          # as we build that separately.
          gdal = pkgs.gdal.overrideAttrs (old: {
            doInstallCheck = false;
            doCheck = false;
            cmakeFlags = (old.cmakeFlags or [ ]) ++ [
              "-DBUILD_PYTHON_BINDINGS=OFF"
            ];
          });
        in
        super.gdal.overridePythonAttrs (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ gdal ];
            preBuild = (old.preBuild or "") + ''
              substituteInPlace setup.cfg \
                --replace "../../apps/gdal-config" '${gdal}/bin/gdal-config'
            '';
          }
        );

      grandalf = super.grandalf.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
          doCheck = false;
        }
      );

      granian =
        let
          getRepoHash = version: {
            "0.2.1" = "sha256-XEhu6M1hFi3/gAKZcei7KJSrIhhlZhlvZvbfyA6VLR4=";
            "0.2.2" = "sha256-KWwefJ3CfOUGCgAm7AhFlIxRF9qxNEo3npGOxVJ23FY=";
            "0.2.3" = "sha256-2JnyO0wxkV49R/0wzDb/PnUWWHi3ckwK4nVe7dWeH1k=";
            "0.2.4" = "sha256-GdQJvVPsWgC1z7La9h11x2pRAP+L998yImhTFrFT5l8=";
            "0.2.5" = "sha256-vMXMxss77rmXSjoB53eE8XN2jXyIEf03WoQiDfvhDmw=";
            "0.2.6" = "sha256-l9W9+KDg/43mc0toEz1n1pqw+oQdiHdAxGlS+KLIGhw=";
            "0.3.0" = "sha256-icBjtW8fZjT3mLo43nKWdirMz6GZIy/RghEO95pHJEU=";
            "0.3.1" = "sha256-EKK+RxkJ//fY43EjvN1Fry7mn2ZLIaNlTyKPJRxyKZs=";
          }.${version};
          sha256 = getRepoHash super.granian.version;
        in
        super.granian.overridePythonAttrs (old: rec {
          src = pkgs.fetchFromGitHub {
            owner = "emmett-framework";
            repo = "granian";
            rev = "v${old.version}";
            inherit sha256;
          };
          cargoDeps = pkgs.rustPlatform.importCargoLock {
            lockFile = "${src.out}/Cargo.lock";
          };
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.rustPlatform.cargoSetupHook
            pkgs.rustPlatform.maturinBuildHook
          ];
        });

      gitpython = super.gitpython.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.typing-extensions ];
        }
      );

      grpcio = super.grpcio.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
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

      gunicorn = super.gunicorn.overridePythonAttrs (old: {
        # actually needs setuptools as a runtime dependency
        propagatedBuildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];
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
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
              buildInputs =
                (old.buildInputs or [ ])
                ++ [ pkgs.hdf5 self.pkgconfig ]
                ++ lib.optional mpiSupport mpi
              ;
              propagatedBuildInputs =
                (old.propagatedBuildInputs or [ ])
                ++ lib.optionals mpiSupport [ self.mpi4py pkgs.openssh ]
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

      hikari = super.hikari.overrideAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];
        }
      );

      hikari-lightbulb = super.hikari-lightbulb.overrideAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];
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

      igraph = super.igraph.overridePythonAttrs (
        old: {
          nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
          dontUseCmakeConfigure = true;
        }
      );

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
        }
      );

      intreehooks = super.intreehooks.overridePythonAttrs (
        old: {
          doCheck = false;
        }
      );

      ipython = super.ipython.overridePythonAttrs (
        old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
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
        }
      );

      trio = super.trio.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
          ++ [ self.async-generator self.idna ];
      });

      jeepney = super.jeepney.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.outcome self.trio ];
      });

      jinja2-ansible-filters = super.jinja2-ansible-filters.overridePythonAttrs (
        old: {
          preBuild = (old.preBuild or "") + ''
            echo "${old.version}" > VERSION
          '';
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

      jsondiff =
        if lib.versionOlder "2.0.0"
        then
          super.jsondiff.overridePythonAttrs
            (
              old: {
                preBuild = lib.optionalString (!(old.src.isWheel or false)) (
                  (old.preBuild or "") + ''
                    substituteInPlace setup.py \
                      --replace "'jsondiff=jsondiff.cli:main_deprecated'," ""
                  ''
                );
              }
            )
        else super.jsondiff;

      jsonslicer = super.jsonslicer.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkgconfig ];
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.yajl ];
      });

      jsonschema =
        if lib.versionAtLeast super.jsonschema.version "4.0.0"
        then
          super.jsonschema.overridePythonAttrs
            (old: {
              propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.importlib-resources ];
            })
        else super.jsonschema;

      jupyter = super.jupyter.overridePythonAttrs (
        old: {
          # jupyter is a meta-package. Everything relevant comes from the
          # dependencies. It does however have a jupyter.py file that conflicts
          # with jupyter-core so this meta solves this conflict.
          meta.priority = 100;
        }
      );

      jupyter-packaging = super.jupyter-packaging.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools self.wheel ];
      });

      jupyter-server = super.jupyter-server.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ])
          ++ [ self.hatchling ];
        buildInputs = (old.buildInputs or [ ])
          ++ [ self.hatch-jupyter-builder ];
      });

      jupyterlab-widgets = super.jupyterlab-widgets.overridePythonAttrs (
        old: {
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

      libarchive = super.libarchive.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools ];

        postPatch = ''
          substituteInPlace libarchive/library.py --replace \
            "_FILEPATH = find_and_load_library()" "_FILEPATH = '${pkgs.libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
        '';
      });

      libvirt-python = super.libvirt-python.overridePythonAttrs ({ nativeBuildInputs ? [ ], ... }: {
        nativeBuildInputs = nativeBuildInputs ++ [ pkg-config ];
        propagatedBuildInputs = [ pkgs.libvirt ];
      });

      lightgbm = super.lightgbm.overridePythonAttrs (
        old: {
          nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
          dontUseCmakeConfigure = true;
          postConfigure = ''
            export HOME=$(mktemp -d)
          '';
        }
      );

      llama-cpp-python = super.llama-cpp-python.overridePythonAttrs (
        old: {
          buildInputs = with pkgs; lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Accelerate
          ];
          nativeBuildInputs = [ pkgs.cmake ] ++ (old.nativeBuildInputs or [ ]);
          preBuild = ''
            cd "$OLDPWD"
          '';
        }
      );

      llvmlite = super.llvmlite.overridePythonAttrs (
        old:
        let
          # see https://github.com/numba/llvmlite#compatibility
          llvm_version = toString (
            if lib.versionAtLeast old.version "0.40.0" then 14
            else if lib.versionAtLeast old.version "0.37.0" then 11
            else if lib.versionAtLeast old.version "0.34.0" && !stdenv.buildPlatform.isAarch64 then 10
            else if lib.versionAtLeast old.version "0.33.0" then 9
            else if lib.versionAtLeast old.version "0.29.0" then 8
            else if lib.versionAtLeast old.version "0.27.0" then 7
            else if lib.versionAtLeast old.version "0.23.0" then 6
            else if lib.versionAtLeast old.version "0.21.0" then 5
            else 4
          );
          llvm = pkgs."llvmPackages_${llvm_version}".llvm or (throw "LLVM${llvm_version} has been removed from nixpkgs; upgrade llvmlite or use older nixpkgs");
        in
        {
          inherit llvm;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.llvmlite.llvm ];

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

      lsassy =
        if super.lsassy.version == "3.1.1" then
          super.lsassy.overridePythonAttrs
            (old: {
              # pyproject.toml contains a constraint `rich = "^10.6.0"` which is not replicated in setup.py
              # hence pypi misses it and poetry pins rich to 11.0.0
              preConfigure = (old.preConfigure or "") + ''
                rm pyproject.toml
              '';
            }) else super.lsassy;

      lxml = super.lxml.overridePythonAttrs (
        old: {
          nativeBuildInputs = with pkgs.buildPackages; (old.nativeBuildInputs or [ ]) ++ [ pkg-config libxml2.dev libxslt.dev ] ++ lib.optionals stdenv.isDarwin [ xcodebuild ];
          buildInputs = with pkgs; (old.buildInputs or [ ]) ++ [ libxml2 libxslt ];
        }
      );

      markdown-it-py = super.markdown-it-py.overridePythonAttrs (
        old: {
          propagatedBuildInputs = builtins.filter (i: i.pname != "mdit-py-plugins") old.propagatedBuildInputs;
          preConfigure = lib.optionalString (!(old.src.isWheel or false)) (
            (old.preConfigure or "") + ''
              substituteInPlace pyproject.toml --replace 'plugins = ["mdit-py-plugins"]' 'plugins = []'
            ''
          );
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
          enableGhostscript = old.passthru.args.enableGhostscript or false;
          enableGtk3 = old.passthru.args.enableGtk3 or false;
          enableQt = old.passthru.args.enableQt or false;
          enableTk = old.passthru.args.enableTk or false;

          interactive = enableTk || enableGtk3 || enableQt;

          passthru = {
            config = {
              directories = { basedirlist = "."; };
              libs = {
                system_freetype = true;
                system_qhull = true;
              } // lib.optionalAttrs stdenv.isDarwin {
                # LTO not working in darwin stdenv, see Nixpkgs #19312
                enable_lto = false;
              };
            };
          };

          inherit (pkgs) tk tcl wayland qhull;
          inherit (pkgs.xorg) libX11;
          inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
        in
        {
          XDG_RUNTIME_DIR = "/tmp";

          buildInputs = old.buildInputs or [ ] ++ [
            pkgs.which
          ] ++ lib.optionals enableGhostscript [
            pkgs.ghostscript
          ] ++ lib.optionals stdenv.isDarwin [
            Cocoa
          ] ++ lib.optionals (lib.versionAtLeast super.matplotlib.version "3.7.0") [
            self.pybind11
          ];

          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
            self.certifi
            pkgs.libpng
            pkgs.freetype
            qhull
          ]
            ++ lib.optionals enableGtk3 [ pkgs.cairo self.pycairo pkgs.gtk3 pkgs.gobject-introspection self.pygobject3 ]
            ++ lib.optionals enableTk [ pkgs.tcl pkgs.tk self.tkinter pkgs.libX11 ]
            ++ lib.optionals enableQt [ self.pyqt5 ]
          ;

          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkg-config
          ] ++ lib.optionals (lib.versionAtLeast super.matplotlib.version "3.5.0") [
            self.setuptools-scm
            self.setuptools-scm-git-archive
          ];

          # Clang doesn't understand -fno-strict-overflow, and matplotlib builds with -Werror
          hardeningDisable = if stdenv.isDarwin then [ "strictoverflow" ] else [ ];

          passthru = old.passthru or { } // passthru;

          MPLSETUPCFG = pkgs.writeText "mplsetup.cfg" (lib.generators.toINI { } passthru.config);

          # Matplotlib tries to find Tcl/Tk by opening a Tk window and asking the
          # corresponding interpreter object for its library paths. This fails if
          # `$DISPLAY` is not set. The fallback option assumes that Tcl/Tk are both
          # installed under the same path which is not true in Nix.
          # With the following patch we just hard-code these paths into the install
          # script.
          postPatch =
            let
              tcl_tk_cache = ''"${tk}/lib", "${tcl}/lib", "${lib.strings.substring 0 3 tk.version}"'';
            in
            lib.optionalString enableTk ''
              sed -i '/self.tcl_tk_cache = None/s|None|${tcl_tk_cache}|' setupext.py
            '' + lib.optionalString (stdenv.isLinux && interactive) ''
              # fix paths to libraries in dlopen calls (headless detection)
              substituteInPlace src/_c_internal_utils.c \
                --replace libX11.so.6 ${libX11}/lib/libX11.so.6 \
                --replace libwayland-client.so.0 ${wayland}/lib/libwayland-client.so.0
            '' +
            # avoid matplotlib trying to download dependencies
            ''
              echo "[libs]
              system_freetype=true
              system_qhull=true" > mplsetup.cfg
            '';

        }
      );

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
              buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools self.setuptools-scm self.setuptools-scm-git-archive ];
            }
          )) else
          super.molecule.overridePythonAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools self.setuptools-scm self.setuptools-scm-git-archive ];
          });

      munch = super.munch.overridePythonAttrs (
        old: {
          # Latest version of pypi imports pkg_resources at runtime, so setuptools is needed at runtime. :(
          # They fixed this last year but never released a new version.
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
        }
      );

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

      mypy = super.mypy.overridePythonAttrs (
        old:
        let
          # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
          # version is also the default in the wheels on Pypi that include binaries.
          # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
          MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

          envAttrs =
            if old ? env
            then { env = old.env // { inherit MYPY_USE_MYPYC; }; }
            else { inherit MYPY_USE_MYPYC; };
        in
        {
          buildInputs = (old.buildInputs or [ ]) ++ [
            self.types-typed-ast
            self.types-setuptools
          ]
          ++ lib.optional (lib.strings.versionAtLeast old.version "0.990") self.types-psutil
          ;

          # when testing reduce optimisation level to drastically reduce build time
          # (default is 3)
          # MYPYC_OPT_LEVEL = 1;
        } // envAttrs // lib.optionalAttrs (old.format != "wheel") {
          # FIXME: Remove patch after upstream has decided the proper solution.
          #        https://github.com/python/mypy/pull/11143
          patches = (old.patches or [ ]) ++ lib.optionals ((lib.strings.versionAtLeast old.version "0.900") && lib.strings.versionOlder old.version "0.940") [
            (pkgs.fetchpatch {
              url = "https://github.com/python/mypy/commit/f1755259d54330cd087cae763cd5bbbff26e3e8a.patch";
              sha256 = "sha256-5gPahX2X6+/qUaqDQIGJGvh9lQ2EDtks2cpQutgbOHk=";
            })
          ] ++ lib.optionals ((lib.strings.versionAtLeast old.version "0.940") && lib.strings.versionOlder old.version "0.960") [
            (pkgs.fetchpatch {
              url = "https://github.com/python/mypy/commit/e7869f05751561958b946b562093397027f6d5fa.patch";
              sha256 = "sha256-waIZ+m3tfvYE4HJ8kL6rN/C4fMjvLEe9UoPbt9mHWIM=";
            })
          ] ++ lib.optionals ((lib.strings.versionAtLeast old.version "0.960") && (lib.strings.versionOlder old.version "0.971")) [
            (pkgs.fetchpatch {
              url = "https://github.com/python/mypy/commit/2004ae023b9d3628d9f09886cbbc20868aee8554.patch";
              sha256 = "sha256-y+tXvgyiECO5+66YLvaje8Bz5iPvfWNIBJcsnZ2nOdI=";
            })
          ];
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
          # fails to build with format=pyproject and setuptools >= 65
          format = if (old.format == "poetry2nix") then "setuptools" else old.format;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.gfortran ];
          buildInputs = (old.buildInputs or [ ]) ++ [ blas ];
          enableParallelBuilding = true;
          preBuild = ''
            ln -s ${cfg} site.cfg
          '';
          preConfigure = ''
            export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
          '';
          passthru = old.passthru // {
            blas = blas;
            inherit blasImplementation cfg;
          };
        }
      );

      # The following are dependencies of torch >= 2.0.0.
      # torch doesn't officially support system CUDA, unless you build it yourself.
      nvidia-cudnn-cu11 = super.nvidia-cudnn-cu11.overridePythonAttrs (attrs: {
        autoPatchelfIgnoreMissingDeps = true;
        # (Bytecode collision happens with nvidia-cuda-nvrtc-cu11.)
        postFixup = ''
          rm -r $out/${self.python.sitePackages}/nvidia/{__pycache__,__init__.py}
        '';
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
          self.nvidia-cublas-cu11
        ];
      });

      nvidia-cuda-nvrtc-cu11 = super.nvidia-cuda-nvrtc-cu11.overridePythonAttrs (_: {
        # (Bytecode collision happens with nvidia-cudnn-cu11.)
        postFixup = ''
          rm -r $out/${self.python.sitePackages}/nvidia/{__pycache__,__init__.py}
        '';
      });

      nvidia-cusolver-cu11 = super.nvidia-cusolver-cu11.overridePythonAttrs (attrs: {
        autoPatchelfIgnoreMissingDeps = true;
        # (Bytecode collision happens with nvidia-cusolver-cu11.)
        postFixup = ''
          rm -r $out/${self.python.sitePackages}/nvidia/{__pycache__,__init__.py}
        '';
        propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
          self.nvidia-cublas-cu11
        ];
      });

      omegaconf = super.omegaconf.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.jdk ];
        }
      );

      open3d = super.open3d.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.ipywidgets ];
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.libusb1
        ] ++ lib.optionals stdenv.isLinux [
          pkgs.udev
        ] ++ lib.optionals (lib.versionAtLeast super.open3d.version "0.16.0") [
          pkgs.mesa
          (
            pkgs.symlinkJoin {
              name = "llvm-with-ubuntu-compatible-symlink";
              paths = [
                pkgs.llvm_10.lib
                (pkgs.runCommand "llvm-ubuntu-compatible-symlink" { }
                  ''
                    mkdir -p "$out/lib/";
                    ln -s "${pkgs.llvm_10.lib}/lib/libLLVM-10.so" "$out/lib/libLLVM-10.so.1"
                  ''
                )
              ];
            })
        ];

        # Patch the dylib in the binary distribution to point to the nix build of libomp
        preFixup = lib.optionalString (stdenv.isDarwin && lib.versionAtLeast super.open3d.version "0.16.0") ''
          install_name_tool -change /opt/homebrew/opt/libomp/lib/libomp.dylib ${pkgs.llvmPackages.openmp}/lib/libomp.dylib $out/lib/python*/site-packages/open3d/cpu/pybind.cpython-*-darwin.so
        '';

        # TODO(Sem Mulder): Add overridable flags for CUDA/PyTorch/Tensorflow support.
        autoPatchelfIgnoreMissingDeps = true;
      });

      openbabel-wheel = super.openbabel-wheel.override { preferWheel = true; };

      # Overrides for building packages based on OpenCV
      # These flags are inspired by the opencv 4.x package in nixpkgs
      _opencv-python-override =
        old: {
          # Disable OpenCL on macOS
          # Can't use cmakeFlags because cmake is called by setup.py
          CMAKE_ARGS = lib.optionalString stdenv.isDarwin "-DWITH_OPENCL=OFF";

          nativeBuildInputs = [ pkgs.cmake ] ++ old.nativeBuildInputs;
          buildInputs = [
            self.scikit-build
          ] ++ lib.optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
            Accelerate
            AVFoundation
            Cocoa
            CoreMedia
            MediaToolbox
            VideoDecodeAcceleration
          ]) ++ (old.buildInputs or [ ]);
          dontUseCmakeConfigure = true;
        };

      opencv-python = super.opencv-python.overridePythonAttrs self._opencv-python-override;

      opencv-python-headless = super.opencv-python-headless.overridePythonAttrs self._opencv-python-override;

      opencv-contrib-python = super.opencv-contrib-python.overridePythonAttrs self._opencv-python-override;

      openexr = super.openexr.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openexr pkgs.ilmbase ];
          NIX_CFLAGS_COMPILE = [ "-I${pkgs.openexr.dev}/include/OpenEXR" "-I${pkgs.ilmbase.dev}/include/OpenEXR" ];
        }
      );

      openvino = super.openvino.overridePythonAttrs (
        old: {
          buildInputs = [
            pkgs.ocl-icd
            pkgs.hwloc
            pkgs.tbb
            pkgs.numactl
            pkgs.libxml2
          ] ++ (old.buildInputs or [ ]);
        }
      );

      orjson =
        let
          getCargoHash = version: {
            "3.6.7" = "sha256-sz2k9podPB6QSptkyOu7+BoVTrKhefizRtYU+MICPt4=";
            "3.6.8" = "sha256-vpfceVtYkU09xszNIihY1xbqGWieqDquxwsAmDH8jd4=";
            "3.7.2" = "sha256-2U37IhftNYjH7sV7Nh51YpR/WjmPmmzX/aGuHsFgwf4=";
            "3.7.9" = "sha256-QHzAhjHgm4XLxY2zUdnIsd/WWMI7dJLQQAvTXC+2asQ=";
            "3.8.0" = "sha256-8k0DetamwLqkdcg8V/D2J5ja6IJSLi50CE+ZjFa7Hdc=";
            "3.8.1" = "sha256-QXguyDxQHW9Fd3Nhmi5JzSxZQuk3HGPhhh/RGuOTZNY=";
            "3.8.3" = "sha256-oSZO4cN1sJKd0T7pYrKG63is8AZMKaLRZqj5UCVY/14=";
            "3.8.4" = "sha256-O2W9zO7qHWG+78T+uECICAmecaSIbTTJPktJIPZYElE=";
            "3.8.5" = "sha256-JtUCJ3TP9EKGcddeyW1e/72k21uKneq9SnZJeLvn9Os=";
            "3.8.6" = "sha256-8T//q6nQoZhh8oJWDCeQf3gYRew58dXAaxkYELY4CJM=";
            "3.8.7" = "sha256-JBO8nl0sC+XIn17vI7hC8+nA1HYI9jfvZrl9nCE3k1s=";
            "3.8.8" = "sha256-AK4HtqPKg2O2FeLHCbY9o+N1BV4QFMNaHVE1NaFYHa4=";
            "3.8.10" = "sha256-AcrTEHv7GYtGe4fXYsM24ElrzfhnOxLYlaon1ZrlD4A=";
          }.${version} or (
            lib.warn "Unknown orjson version: '${version}'. Please update getCargoHash." lib.fakeHash
          );
        in
        super.orjson.overridePythonAttrs (old: if old.src.isWheel or false then { } else {
          cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
            inherit (old) src;
            name = "${old.pname}-${old.version}";
            hash = getCargoHash old.version;
          };
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.rustPlatform.cargoSetupHook
            pkgs.rustPlatform.maturinBuildHook
          ];
          buildInputs = (old.buildInputs or [ ]) ++ lib.optional pkgs.stdenv.isDarwin pkgs.libiconv;
        });

      osqp = super.osqp.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.cmake ];
          dontUseCmakeConfigure = true;
        }
      );


      pandas = super.pandas.overridePythonAttrs (old: {

        buildInputs = old.buildInputs or [ ] ++ lib.optional stdenv.isDarwin pkgs.libcxx;

        # Doesn't work with -Werror,-Wunused-command-line-argument
        # https://github.com/NixOS/nixpkgs/issues/39687
        hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

        # For OSX, we need to add a dependency on libcxx, which provides
        # `complex.h` and other libraries that pandas depends on to build.
        postPatch = lib.optionalString (!(old.src.isWheel or false) && stdenv.isDarwin) ''
          cpp_sdk="${lib.getDev pkgs.libcxx}/include/c++/v1";
          echo "Adding $cpp_sdk to the setup.py common_include variable"
          substituteInPlace setup.py \
            --replace "['pandas/src/klib', 'pandas/src']" \
                      "['pandas/src/klib', 'pandas/src', '$cpp_sdk']"
        '';


        enableParallelBuilding = true;
      });

      pantalaimon = super.pantalaimon.overridePythonAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.installShellFiles ];
        postInstall = old.postInstall or "" + ''
          installManPage docs/man/*.[1-9]
        '';
      });

      pao = super.pao.overridePythonAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [ self.pyutilib ];
      });

      paramiko = super.paramiko.overridePythonAttrs (old: {
        doCheck = false; # requires networking
      });

      parsel = super.parsel.overridePythonAttrs (
        old: {
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

      pikepdf = super.pikepdf.overridePythonAttrs (
        old: {
          buildInputs = old.buildInputs or [ ] ++ [ pkgs.qpdf self.pybind11 ];
          pythonImportsCheck = old.pythonImportsCheck or [ ] ++ [ "pikepdf" ];
        }
      );

      pillow = super.pillow.overridePythonAttrs (
        old:
        let
          preConfigure = (old.preConfigure or "") + pkgs.python3.pkgs.pillow.preConfigure;
        in
        {
          nativeBuildInputs = (old.nativeBuildInputs or [ ])
            ++ [ pkg-config self.pytest-runner ];
          buildInputs = with pkgs; (old.buildInputs or [ ])
            ++ [ freetype libjpeg zlib libtiff libxcrypt libwebp tcl lcms2 ]
            ++ lib.optionals (lib.versionAtLeast old.version "7.1.0") [ xorg.libxcb ]
            ++ lib.optionals (self.isPyPy) [ tk xorg.libX11 ];
          preConfigure = lib.optional (old.format != "wheel") preConfigure;
        }
      );

      pip-requirements-parser = super.pip-requirements-parser.overridePythonAttrs (old: {
        dontConfigure = true;
      });

      pluralizer = super.pluralizer.overridePythonAttrs (old: {
        preBuild = ''
          export PYPI_VERSION="${old.version}"
        '';
      });

      poethepoet = super.poethepoet.overrideAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs ++ [ self.poetry ];
      });

      poetry-core = super.poetry-core.overridePythonAttrs (old:
        let
          initFile =
            if lib.versionOlder super.poetry-core.version "1.1"
            then "poetry/__init__.py"
            else "./src/poetry/core/__init__.py";
        in
        {
          # "Vendor" dependencies (for build-system support)
          postPatch = ''
            echo "import sys" >> ${initFile}
            for path in $propagatedBuildInputs; do
              echo "sys.path.insert(0, \"$path\")" >> ${initFile}
            done
          '';

          # Propagating dependencies leads to issues downstream
          # We've already patched poetry to prefer "vendored" dependencies
          postFixup = ''
            rm $out/nix-support/propagated-build-inputs
          '';
        });

      # Requires poetry which isn't available during bootstrap
      poetry-plugin-export = super.poetry-plugin-export.overridePythonAttrs (old: {
        dontUsePythonImportsCheck = true;
        pipInstallFlags = [
          "--no-deps"
        ];
      });

      portend = super.portend.overridePythonAttrs (
        old: {
          # required for the extra "toml" dependency in setuptools_scm[toml]
          buildInputs = (old.buildInputs or [ ]) ++ [
            self.toml
          ];
        }
      );

      prettytable = super.prettytable.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
      });

      prophet = super.prophet.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.cmdstan self.cmdstanpy ];
        PROPHET_REPACKAGE_CMDSTAN = "false";
        CMDSTAN = "${pkgs.cmdstan}";
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

      psycopg2cffi = super.psycopg2cffi.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ])
            ++ lib.optional stdenv.isDarwin pkgs.openssl;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.postgresql ];
        }
      );

      py-solc-x = super.py-solc-x.overridePythonAttrs (
        old: {
          preConfigure = ''
            substituteInPlace setup.py --replace \'setuptools-markdown\' ""
          '';
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.requests self.semantic-version ];
        }
      );

      pyarrow =
        if (!super.pyarrow.src.isWheel or false) && lib.versionAtLeast super.pyarrow.version "0.16.0" then
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
                  pkg-config
                  pkgs.cmake
                ];

                buildInputs = (old.buildInputs or [ ]) ++ [
                  _arrow-cpp
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
          super.pyarrow;

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
              self.meson
              pkgs.ninja
              pkg-config
            ];

            propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
              pkgs.cairo
            ];

            mesonFlags = [ "-Dpython=${if self.isPy3k then "python3" else "python"}" ];
          }
        )
      )
        super.pycairo;

      pycocotools = super.pycocotools.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [
            self.numpy
          ];
        }
      );

      pyfftw = super.pyfftw.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.fftw
          pkgs.fftwFloat
          pkgs.fftwLongDouble
        ];
      });

      pyfuse3 = super.pyfuse3.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.fuse3 ];
      });

      pygame = super.pygame.overridePythonAttrs (
        old: rec {
          nativeBuildInputs = [
            pkg-config
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
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.glib pkgs.gobject-introspection ];
        }
      );

      pylint = super.pylint.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
        }
      );

      pymediainfo = super.pymediainfo.overridePythonAttrs (
        old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace pymediainfo/__init__.py \
              --replace "libmediainfo.0.dylib" \
                        "${pkgs.libmediainfo}/lib/libmediainfo.0${stdenv.hostPlatform.extensions.sharedLibrary}" \
              --replace "libmediainfo.dylib" \
                        "${pkgs.libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}" \
              --replace "libmediainfo.so.0" \
                        "${pkgs.libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}.0"
          '';
        }
      );

      pynetbox = super.pynetbox.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.setuptools ];
      });

      pynput = super.pynput.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ])
          ++ [ self.sphinx ];

        propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
          ++ [ self.setuptools-lint ];
      });

      pymssql = super.pymssql.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ])
          ++ [ pkgs.openssl pkgs.libkrb5 ];
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
          ++ [ pkgs.freetds ];
      });

      pyopencl = super.pyopencl.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.numpy ];
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.ocl-icd pkgs.opencl-headers ];
        }
      );

      pyopenssl = super.pyopenssl.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl ];
        }
      );

      pyproj = super.pyproj.overridePythonAttrs (
        old: {
          PROJ_DIR = "${pkgs.proj}";
          PROJ_LIBDIR = "${pkgs.proj}/lib";
          PROJ_INCDIR = "${pkgs.proj.dev}/include";
        }
      );

      pyrealsense2 = super.pyrealsense2.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libusb1.out ];
      });

      pyrfr = super.pyrfr.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.swig ];
      });

      pyscard = super.pyscard.overridePythonAttrs (old:
        # see https://github.com/NixOS/nixpkgs/blob/93568862a610dc1469dc40b15c1096a9357698ac/pkgs/development/python-modules/pyscard/default.nix
        let
          inherit (pkgs) PCSC pcsclite;
          withApplePCSC = stdenv.isDarwin;
        in
        {
          postPatch =
            if withApplePCSC then ''
              substituteInPlace smartcard/scard/winscarddll.c \
                --replace "/System/Library/Frameworks/PCSC.framework/PCSC" \
                          "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
            '' else ''
              substituteInPlace smartcard/scard/winscarddll.c \
                --replace "libpcsclite.so.1" \
                          "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
            '';
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ (
            if withApplePCSC then [ PCSC ] else [ pcsclite ]
          );
          NIX_CFLAGS_COMPILE = lib.optionalString (! withApplePCSC)
            "-I ${lib.getDev pcsclite}/include/PCSC";
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.swig
          ];
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

      python-snap7 = super.python-snap7.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
          pkgs.snap7
        ];

        postPatch = (old.postPatch or "") + ''
          echo "Patching find_library call."
          substituteInPlace snap7/common.py \
            --replace "find_library('snap7')" "\"${pkgs.snap7}/lib/libsnap7.so\""
        '';
      });


      pytoml = super.pytoml.overridePythonAttrs (
        old: {
          doCheck = false;
        }
      );

      pytorch-lightning = super.pytorch-lightning.override {
        unpackPhase = ''
          # $src remains a gzipped tarball otherwise.
          mkdir -p tmp
          tar xvf $src --directory=tmp
          mv tmp/pytorch-lightning*/* .
          rm -rf tmp
        '';
      };

      pyqt5 =
        let
          qt5 = selectQt5 super.pyqt5.version;
        in
        super.pyqt5.overridePythonAttrs (
          old: {
            postPatch = ''
              # Confirm license
              sed -i s/"if tool == 'pep517':"/"if True:"/ project.py
            '';

            dontConfigure = true;
            dontWrapQtApps = true;
            nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
              self.pyqt-builder
              self.sip
              qt5.full
            ];
          }
        );

      pyqt5-qt5 =
        let
          qt5 = selectQt5 super.pyqt5-qt5.version;
        in
        super.pyqt5-qt5.overridePythonAttrs (
          old: {
            dontWrapQtApps = true;
            propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [
              qt5.full
              qt5.qtgamepad # As of 2022-05-13 not a port of qt5.full
              pkgs.gtk3
              pkgs.speechd
              pkgs.postgresql
              pkgs.unixODBC
            ];
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
            # sometimes setup.cfg doesn't exist
            if [ -f setup.cfg ]; then
              sed -i '/\[metadata\]/aversion = ${old.version}' setup.cfg
            fi
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

      python-magic = super.python-magic.overridePythonAttrs (
        old: {
          postPatch = ''
            substituteInPlace magic/loader.py \
              --replace "'libmagic.so.1'" "'${lib.getLib pkgs.file}/lib/libmagic.so.1'"
          '';
          pythonImportsCheck = old.pythonImportsCheck or [ ] ++ [ "magic" ];
        }
      );

      python-olm = super.python-olm.overridePythonAttrs (
        old: {
          buildInputs = old.buildInputs or [ ] ++ [ pkgs.olm ];
        }
      );

      python-pam = super.python-pam.overridePythonAttrs (
        old: {
          postPatch = ''
            substituteInPlace src/pam/__internals.py \
            --replace 'find_library("pam")' '"${pkgs.pam}/lib/libpam.so"' \
            --replace 'find_library("pam_misc")' '"${pkgs.pam}/lib/libpam_misc.so"'
          '';
        }
      );

      python-snappy = super.python-snappy.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.snappy ];
        }
      );

      python-twitter = super.python-twitter.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.pytest-runner ];
      });

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
            --replace "find_library(name)" "'${lib.getLib pkgs.systemd}/lib/libudev.so'"
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
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.zeromq ];
        }
      );

      recommonmark = super.rich.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.commonmark ];
        }
      );

      rich = super.rich.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.commonmark ];
        }
      );

      rockset = super.rockset.overridePythonAttrs (
        old: {
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

          # Link include and share so it can be used by packages that use pybind11 through cmake
          postInstall = ''
            ln -s $out/${self.python.sitePackages}/pybind11/{include,share} $out/
          '';
        }
      );

      rasterio = super.rasterio.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.gdal ];
      });

      rfc3986-validator = super.rfc3986-validator.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          self.pytest-runner
        ];
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
            lib.optionals (lib.versionAtLeast super.scipy.version "1.7.0") [ self.pythran ] ++
            lib.optionals (lib.versionAtLeast super.scipy.version "1.9.0") [ self.meson-python pkg-config ];
          dontUseMesonConfigure = true;
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ self.pybind11 ];
          setupPyBuildFlags = [ "--fcompiler='gnu95'" ];
          enableParallelBuilding = true;
          buildInputs = (old.buildInputs or [ ]) ++ [ self.numpy.blas ];
          preConfigure = ''
            sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
            export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
          '';
          preBuild = lib.optional (lib.versionOlder super.scipy.version "1.9.0") ''
            ln -s ${self.numpy.cfg} site.cfg
          '';
        } else old
      );

      scikit-image = super.scikit-image.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
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
          ] ++ lib.optionals stdenv.cc.isClang [
            pkgs.llvmPackages.openmp
          ] ++ lib.optionals stdenv.isLinux [
            pkgs.glibcLocales
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
            --replace 'setuptools_version.' '"${self.setuptools.version}".' \
            --replace 'pytest-runner==' 'pytest-runner>='
        '';
      });

      selenium =
        let
          v4orLater = lib.versionAtLeast super.selenium.version "4";
          selenium = super.selenium.override {
            # Selenium >=4 is built with Bazel
            preferWheel = v4orLater;
          };
        in
        selenium.overridePythonAttrs (old: {
          # Selenium <4 can be installed from sources, with setuptools
          buildInputs = old.buildInputs ++ (lib.optionals (!v4orLater) [ self.setuptools ]);
        });

      shapely = super.shapely.overridePythonAttrs (
        old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.geos ];

          GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

          GEOS_LIBC = lib.optionalString (!stdenv.isDarwin) "${lib.getLib stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";

          # Fix library paths
          postPatch = lib.optionalString (!(old.src.isWheel or false)) (old.postPatch or "" + ''
            ${pkgs.python3.interpreter} ${./shapely-rewrite.py} shapely/geos.py
          '');
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

      soundfile = super.soundfile.overridePythonAttrs (old: {
        postPatch = ''
          substituteInPlace soundfile.py --replace "_find_library('sndfile')" "'${pkgs.libsndfile.out}/lib/libsndfile${stdenv.hostPlatform.extensions.sharedLibrary}'"
        '';
      });

      suds = super.suds.overridePythonAttrs (old: {
        # Fix naming convention shenanigans.
        # https://github.com/suds-community/suds/blob/a616d96b070ca119a532ff395d4a2a2ba42b257c/setup.py#L648
        SUDS_PACKAGE = "suds";
      });

      systemd-python = super.systemd-python.overridePythonAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.systemd ];
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.pkg-config ];
      });

      tables = super.tables.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pywavelets ];
          HDF5_DIR = lib.getDev pkgs.hdf5;
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
          propagatedBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.hdf5 self.numpy self.numexpr ];
        }
      );

      tempora = super.tempora.overridePythonAttrs (
        old: {
          # required for the extra "toml" dependency in setuptools_scm[toml]
          buildInputs = (old.buildInputs or [ ]) ++ [
            self.toml
          ];
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

      tensorflow-macos = super.tensorflow-macos.overridePythonAttrs (
        old: {
          postInstall = self.tensorflow.postInstall;
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

      torch = super.torch.overridePythonAttrs (old: {
        # torch has an auto-magical way to locate the cuda libraries from site-packages.
        autoPatchelfIgnoreMissingDeps = true;
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
          self.numpy
        ];
      });

      torchvision = super.torchvision.overridePythonAttrs (old: {
        autoPatchelfIgnoreMissingDeps = true;

        # (no patchelf on darwin, since no elves there.)
        preFixup = lib.optionals (!stdenv.isDarwin) ''
          addAutoPatchelfSearchPath "${self.torch}/${self.python.sitePackages}/torch/lib"
        '';

        buildInputs = (old.buildInputs or [ ]) ++ [
          self.torch
        ];
      });

      # Circular dependency between triton and torch (see https://github.com/openai/triton/issues/1374)
      # You can remove this once triton publishes a new stable build and torch takes it.
      triton = super.triton.overridePythonAttrs (old: {
        propagatedBuildInputs = builtins.filter (e: e.pname != "torch") old.propagatedBuildInputs;
        pipInstallFlags = [ "--no-deps" ];
      });

      typed_ast = super.typed-ast.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
          self.pytest-runner
        ];
      });

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
        wheel = ((if self.python.isPy2 then pkgs.python2 else pkgs.python3).pkgs.override {
          python = self.python;
        }).wheel;
      };

      watchfiles =
        let
          # Watchfiles does not include Cargo.lock in tarball released on PyPi for versions up to 0.17.0
          getRepoHash = version: {
            "0.19.0" = "sha256-NmmeoaIfFMNKCcjH6tPnkpflkN35bKlT76MqF9W8LBc=";
            "0.18.1" = "sha256-XEhu6M1hFi3/gAKZcei7KJSrIhhlZhlvZvbfyA6VLR4=";
            "0.18.0" = "sha256-biGGn0YAUbSO1hCJ4kU0ZWlqlXl/HRrBS3iIA3myRI8=";
            "0.17.0" = "1swpf265h9qq30cx55iy6jjirba3wml16wzb68k527ynrxr7hvqx";
            "0.16.1" = "1ss6gzcr6js2d2sddgz1p52gyiwpqmgrxm8r6wim7gnm4wvhav8a";
            "0.15.0" = "14k3avrj7v794kk4mk2xggn40a4s0zg8iq8wmyyyrf7va6hz29hf";
            "0.14.1" = "1pgfbhxrvr3dw46x9piqj3ydxgn4lkrfp931q0cajinrpv4acfay";
            "0.14" = "0lml67ilyly0i632pffdy1gd07404vx90xnkw8q6wf6xp5afmkka";
            "0.13" = "0rkz8yr01mmxm2lcmbnr9i5c7n371mksij7v3ws0aqlrh3kgww02";
            "0.12" = "16788a0d8n1bb705f0k3dvav2fmbbl6pcikwpgarl1l3fcfff8kl";
            "0.11" = "0vx56h9wfxj7x3aq7jign4rnlfm7x9nhjwmsv8p22acbzbs10dgv";
            "0.10" = "0ypdy9sq4211djqh4ni5ap9l7whq9hw0vhsxjfl3a0a4czlldxqp";
          }.${version};
          sha256 = getRepoHash super.watchfiles.version;
        in
        super.watchfiles.overridePythonAttrs (old: rec {
          src = pkgs.fetchFromGitHub {
            owner = "samuelcolvin";
            repo = "watchfiles";
            rev = "v${old.version}";
            inherit sha256;
          };
          patchPhase = builtins.concatStringsSep "\n" [
            (old.patchPhase or "")
            ''
              substituteInPlace "Cargo.lock" --replace 'version = "0.0.0"' 'version = "${old.version}"'
              substituteInPlace "Cargo.toml" --replace 'version = "0.0.0"' 'version = "${old.version}"'
            ''
          ];
          cargoDeps = pkgs.rustPlatform.importCargoLock {
            lockFile = "${src.out}/Cargo.lock";
          };
          buildInputs = (old.buildInputs or [ ]) ++ lib.optionals stdenv.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.Security
            pkgs.darwin.apple_sdk.frameworks.CoreServices
            pkgs.libiconv
          ];
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.rustPlatform.cargoSetupHook
            pkgs.rustPlatform.maturinBuildHook
          ];
        });

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

      wheel = if self.python.isPy2 then
        super.wheel.override {
          inherit (self) bootstrapped-pip;
        }
      else
        super.wheel;

      zipp = if super.zipp == null then null else
      super.zipp.overridePythonAttrs (
        old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
            self.toml
          ];
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
            pkg-config
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
      tqdm = super.tqdm.overridePythonAttrs (
        old: {
          buildInputs = [ super.toml ] ++ (old.buildInputs or [ ]);
        }
      );

      watchdog = super.watchdog.overrideAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ])
            ++ lib.optional pkgs.stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.CoreServices;
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

      minimal-snowplow-tracker = super.minimal-snowplow-tracker.overridePythonAttrs
        (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ super.setuptools ];
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

      pygraphviz = super.pygraphviz.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.graphviz ];
      });

      pysqlite = super.pysqlite.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.sqlite ];
        patchPhase = ''
          substituteInPlace "setup.cfg"                                     \
                  --replace "/usr/local/include" "${pkgs.sqlite.dev}/include"   \
                  --replace "/usr/local/lib" "${pkgs.sqlite.out}/lib"
          ${lib.optionalString (!stdenv.isDarwin) ''export LDSHARED="$CC -pthread -shared"''}
        '';
      });

      selinux = super.selinux.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.setuptools-scm-git-archive ];
      });

      setuptools-scm = super.setuptools-scm.overridePythonAttrs (old: {
        setupHook = pkgs.writeText "setuptools-scm-setup-hook.sh" ''
          poetry2nix-setuptools-scm-hook() {
              if [ -z "''${dontPretendSetuptoolsSCMVersion-}" ]; then
                export SETUPTOOLS_SCM_PRETEND_VERSION="$version"
              fi
          }

          preBuildHooks+=(poetry2nix-setuptools-scm-hook)
        '';
      });

      uwsgi = super.uwsgi.overridePythonAttrs
        (old:
          {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.ncurses ];
          } // lib.optionalAttrs (lib.versionAtLeast old.version "2.0.19" && lib.versionOlder old.version "2.0.20") {
            sourceRoot = ".";
          });

      wcwidth = super.wcwidth.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]);
      });

      wtforms = super.wtforms.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ self.Babel ];
      });

      nbconvert =
        let
          patchExporters = lib.optionalString (lib.versionAtLeast self.nbconvert.version "6.5.0") ''
            substituteInPlace \
              ./nbconvert/exporters/templateexporter.py \
              --replace \
              'root_dirs.extend(jupyter_path())' \
              'root_dirs.extend(jupyter_path() + [os.path.join("@out@", "share", "jupyter")])' \
              --subst-var out
          '';
        in
        super.nbconvert.overridePythonAttrs (old: {
          postPatch = lib.optionalString (!(old.src.isWheel or false)) (
            patchExporters + lib.optionalString (lib.versionAtLeast self.nbconvert.version "7.0") ''
              substituteInPlace \
                ./hatch_build.py \
                --replace \
                'if self.target_name not in ["wheel", "sdist"]:' \
                'if True:'
            ''
          );
          postInstall = lib.optionalString (old.src.isWheel or false) ''
            pushd $out/${self.python.sitePackages}
            ${patchExporters}
            popd
          '';
        });

      meson-python = super.meson-python.overridePythonAttrs (old: {
        dontUseMesonConfigure = true;
      });

      mkdocs = super.mkdocs.overridePythonAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [ self.babel ];
      });

      # patch mkdocstrings to fix jinja2 imports
      mkdocstrings =
        let
          patchJinja2Imports = self.pkgs.fetchpatch {
            name = "fix-jinja2-imports.patch";
            url = "https://github.com/mkdocstrings/mkdocstrings/commit/b37722716b1e0ed6393ec71308dfb0f85e142f3b.patch";
            hash = "sha256-DD1SjEvs5HBlSRLrqP3jhF/yoeWkF7F3VXCD1gyt5Fc=";
          };
        in
        super.mkdocstrings.overridePythonAttrs (
          old: lib.optionalAttrs
            (lib.versionAtLeast old.version "0.17" && lib.versionOlder old.version "0.18")
            {
              patches = old.patches or [ ] ++ lib.optionals (!(old.src.isWheel or false)) [ patchJinja2Imports ];
              # strip the first two levels ("a/src/") when patching since we're in site-packages
              # just above mkdocstrings
              postInstall = lib.optionalString (old.src.isWheel or false) ''
                pushd "$out/${self.python.sitePackages}"
                patch -p2 < "${patchJinja2Imports}"
                popd
              '';
            }
        );

      flake8-mutable = super.flake8-mutable.overridePythonAttrs
        (old: { buildInputs = old.buildInputs or [ ] ++ [ self.pytest-runner ]; });
      pydantic = super.pydantic.overridePythonAttrs
        (old: { buildInputs = old.buildInputs or [ ] ++ [ pkgs.libxcrypt ]; });

      y-py = super.y-py.override {
        preferWheel = true;
      };
    }
  )
]
