# This builder is for FoundationDB CMake build system.

{ lib, fetchFromGitHub
, cmake, ninja, boost, python3, openjdk, mono, libressl

, gccStdenv, llvmPackages
, useClang ? false
, ...
}:

let
  stdenv = if useClang then llvmPackages.libcxxStdenv else gccStdenv;

  tests = with builtins;
    builtins.replaceStrings [ "\n" ] [ " " ] (lib.fileContents ./test-list.txt);

  makeFdb =
    { version
    , branch # unused
    , sha256
    , rev ? "refs/tags/${version}"
    , officialRelease ? true
    , patches ? []
    }: stdenv.mkDerivation {
        pname = "foundationdb";
        inherit version;

        src = fetchFromGitHub {
          owner = "apple";
          repo  = "foundationdb";
          inherit rev sha256;
        };

        buildInputs = [ libressl boost ];
        nativeBuildInputs = [ cmake ninja python3 openjdk mono ]
          ++ lib.optional useClang [ llvmPackages.lld ];

        separateDebugInfo = true;
        dontFixCmake = true;

        cmakeFlags =
          [ "-DCMAKE_BUILD_TYPE=Release"
            (lib.optionalString officialRelease "-DFDB_RELEASE=TRUE")

            # FIXME: why can't libressl be found automatically?
            "-DLIBRESSL_USE_STATIC_LIBS=FALSE"
            "-DLIBRESSL_INCLUDE_DIR=${libressl.dev}"
            "-DLIBRESSL_CRYPTO_LIBRARY=${libressl.out}/lib/libcrypto.so"
            "-DLIBRESSL_SSL_LIBRARY=${libressl.out}/lib/libssl.so"
            "-DLIBRESSL_TLS_LIBRARY=${libressl.out}/lib/libtls.so"

            # LTO brings up overall build time, but results in much smaller
            # binaries for all users and the cache.
            (lib.optionalString (!useClang) "-DUSE_LTO=ON")

            # Gold helps alleviate the link time, especially when LTO is
            # enabled. But even then, it still takes a majority of the time.
            # Same with LLD when Clang is available.
            (lib.optionalString useClang    "-DUSE_LD=LLD")
            (lib.optionalString (!useClang) "-DUSE_LD=GOLD")
          ];

        inherit patches;

        # fix up the use of the very weird and custom 'fdb_install' command by just
        # replacing it with cmake's ordinary version.
        postPatch = ''
          for x in bindings/c/CMakeLists.txt fdbserver/CMakeLists.txt fdbmonitor/CMakeLists.txt fdbbackup/CMakeLists.txt fdbcli/CMakeLists.txt; do
            substituteInPlace $x --replace 'fdb_install' 'install'
          done
        '';

        # the install phase for cmake is pretty wonky right now since it's not designed to
        # coherently install packages as most linux distros expect -- it's designed to build
        # packaged artifacts that are shipped in RPMs, etc. we need to add some extra code to
        # cmake upstream to fix this, and if we do, i think most of this can go away.
        postInstall = ''
          mv $out/sbin/fdbserver $out/bin/fdbserver
          rm -rf \
            $out/lib/systemd $out/Library $out/usr $out/sbin \
            $out/var $out/log $out/etc

          mv $out/fdbmonitor/fdbmonitor $out/bin/fdbmonitor && rm -rf $out/fdbmonitor

          rm -rf $out/lib/foundationdb/
          mkdir $out/libexec && ln -sfv $out/bin/fdbbackup $out/libexec/backup_agent

          mkdir $out/include/foundationdb && \
            mv $out/include/*.h $out/include/*.options $out/include/foundationdb

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

          # include the tests
          mkdir -p $out/share/test
          (cd ../tests && for x in ${tests}; do
            cp --parents $x $out/share/test
          done)
        '';

        outputs = [ "out" "dev" "lib" "pythonsrc" ];

        meta = with lib; {
          description = "Open source, distributed, transactional key-value store";
          homepage    = "https://www.foundationdb.org";
          license     = licenses.asl20;
          platforms   = [ "x86_64-linux" ];
          maintainers = with maintainers; [ thoughtpolice lostnet ];
       };
    };
in makeFdb
