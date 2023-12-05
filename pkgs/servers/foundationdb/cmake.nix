# This builder is for FoundationDB CMake build system.

{ lib, fetchFromGitHub
, cmake, ninja, python3, openjdk8, mono, pkg-config
, msgpack, toml11

, gccStdenv, llvmPackages
, useClang ? false
, ...
}:

let
  stdenv = if useClang then llvmPackages.libcxxStdenv else gccStdenv;

  # Only even numbered versions compile on aarch64; odd numbered versions have avx enabled.
  avxEnabled = version:
    let
      isOdd = n: lib.trivial.mod n 2 != 0;
      patch = lib.toInt (lib.versions.patch version);
    in isOdd patch;

  makeFdb =
    { version
    , hash
    , rev ? "refs/tags/${version}"
    , officialRelease ? true
    , patches ? []
    , boost
    , ssl
    }: stdenv.mkDerivation {
        pname = "foundationdb";
        inherit version;

        src = fetchFromGitHub {
          owner = "apple";
          repo  = "foundationdb";
          inherit rev hash;
        };

        buildInputs = [ ssl boost msgpack toml11 ];

        nativeBuildInputs = [ pkg-config cmake ninja python3 openjdk8 mono ]
          ++ lib.optionals useClang [ llvmPackages.lld ];

        separateDebugInfo = true;
        dontFixCmake = true;

        cmakeFlags =
          [ (lib.optionalString officialRelease "-DFDB_RELEASE=TRUE")

            # Disable CMake warnings for project developers.
            "-Wno-dev"

            # CMake Error at fdbserver/CMakeLists.txt:332 (find_library):
            # >   Could not find lz4_STATIC_LIBRARIES using the following names: liblz4.a
            "-DSSD_ROCKSDB_EXPERIMENTAL=FALSE"

            # FoundationDB's CMake is hardcoded to pull in jemalloc as an external
            # project at build time.
            "-DUSE_JEMALLOC=FALSE"

            # LTO brings up overall build time, but results in much smaller
            # binaries for all users and the cache.
            (lib.optionalString (!useClang) "-DUSE_LTO=ON")

            # Gold helps alleviate the link time, especially when LTO is
            # enabled. But even then, it still takes a majority of the time.
            # Same with LLD when Clang is available.
            (lib.optionalString useClang    "-DUSE_LD=LLD")
            (lib.optionalString (!useClang) "-DUSE_LD=GOLD")
          ] ++ lib.optionals (lib.versionOlder version "7.2.0")
          [ # FIXME: why can't openssl be found automatically?
            "-DOPENSSL_USE_STATIC_LIBS=FALSE"
            "-DOPENSSL_CRYPTO_LIBRARY=${ssl.out}/lib/libcrypto.so"
            "-DOPENSSL_SSL_LIBRARY=${ssl.out}/lib/libssl.so"
          ];

        hardeningDisable = [ "fortify" ];

        env.NIX_CFLAGS_COMPILE = toString [
          # Needed with GCC 12
          "-Wno-error=missing-template-keyword"
          # Needed to compile on aarch64
          (lib.optionalString stdenv.isAarch64 "-march=armv8-a+crc")
        ];

        inherit patches;

        # the install phase for cmake is pretty wonky right now since it's not designed to
        # coherently install packages as most linux distros expect -- it's designed to build
        # packaged artifacts that are shipped in RPMs, etc. we need to add some extra code to
        # cmake upstream to fix this, and if we do, i think most of this can go away.
        postInstall = ''
          mv $out/sbin/fdbmonitor $out/bin/fdbmonitor
          mkdir $out/libexec && mv $out/usr/lib/foundationdb/backup_agent/backup_agent $out/libexec/backup_agent
          mv $out/sbin/fdbserver $out/bin/fdbserver

          rm -rf $out/etc $out/lib/foundationdb $out/lib/systemd $out/log $out/sbin $out/usr $out/var

          # move results into multi outputs
          mkdir -p $dev $lib
          mv $out/include $dev/include
          mv $out/lib $lib/lib

          # python bindings
          # NB: use the original setup.py.in, so we can substitute VERSION correctly
          cp ../LICENSE ./bindings/python
          substitute ../bindings/python/setup.py.in ./bindings/python/setup.py \
            --replace 'VERSION' "${version}"
          rm -f ./bindings/python/setup.py.* ./bindings/python/CMakeLists.txt
          rm -f ./bindings/python/fdb/*.pth # remove useless files
          rm -f ./bindings/python/*.rst ./bindings/python/*.mk

          cp -R ./bindings/python/                          tmp-pythonsrc/
          tar -zcf $pythonsrc --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/

          # java bindings
          mkdir -p $lib/share/java
          mv lib/fdb-java-*.jar $lib/share/java/fdb-java.jar
        '';

        outputs = [ "out" "dev" "lib" "pythonsrc" ];

        meta = with lib; {
          description = "Open source, distributed, transactional key-value store";
          homepage    = "https://www.foundationdb.org";
          license     = licenses.asl20;
          platforms   = [ "x86_64-linux" ]
            ++ lib.optionals (!(avxEnabled version)) [ "aarch64-linux" ];
          maintainers = with maintainers; [ thoughtpolice lostnet ];
       };
    };
in makeFdb
