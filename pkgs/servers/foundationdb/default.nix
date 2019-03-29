{ stdenv49
, lib, fetchurl, fetchpatch, fetchFromGitHub

, which, findutils, m4, gawk
, python, openjdk, mono, libressl
}:

let
  # hysterical raisins dictate a version of boost this old. however,
  # we luckily do not need to build anything, we just need the header
  # files.
  boost152 = stdenv49.mkDerivation rec {
    name = "boost-headers-1.52.0";

    src = fetchurl {
      url = "mirror://sourceforge/boost/boost_1_52_0.tar.bz2";
      sha256 = "14mc7gsnnahdjaxbbslzk79rc0d12h1i681cd3srdwr3fzynlar2";
    };

    configurePhase = ":";
    buildPhase = ":";
    installPhase = "mkdir -p $out/include && cp -R boost $out/include/";
  };

  makeFdb =
    { version
    , branch
    , sha256

    # the revision can be inferred from the fdb tagging policy
    , rev    ? "refs/tags/${version}"

    # in theory newer versions of fdb support newer compilers, but they
    # don't :( maybe one day
    , stdenv ? stdenv49

    # in theory newer versions of fdb support newer boost versions, but they
    # don't :( maybe one day
    , boost ? boost152

    # if an release is unofficial/a prerelease, then make sure this is set
    , officialRelease ? true
    }: stdenv.mkDerivation rec {
        name = "foundationdb-${version}";
        inherit version;

        src = fetchFromGitHub {
          owner = "apple";
          repo  = "foundationdb";
          inherit rev sha256;
        };

        nativeBuildInputs = [ python openjdk gawk which m4 findutils mono ];
        buildInputs = [ libressl boost ];

        patches =
          [ # For 5.2+, we need a slightly adjusted patch to fix all the ldflags
            (if lib.versionAtLeast version "5.2"
             then (if lib.versionAtLeast version "6.0"
                   then ./ldflags-6.0.patch
                   else ./ldflags-5.2.patch)
             else ./ldflags-5.1.patch)
          ]
          # for 6.0+, we do NOT need to apply this version fix, since we can specify
          # it ourselves. see configurePhase
          ++ (lib.optional (!lib.versionAtLeast version "6.0") ./fix-scm-version.patch)
          # Versions less than 6.0 have a busted Python 3 build due to an outdated
          # use of 'print'. Also apply an update to the six module with many bugfixes,
          # which is in 6.0+ as well
          ++ (lib.optional (!lib.versionAtLeast version "6.0") (fetchpatch {
            name   = "update-python-six.patch";
            url    = "https://github.com/apple/foundationdb/commit/4bd9efc4fc74917bc04b07a84eb065070ea7edb2.patch";
            sha256 = "030679lmc86f1wzqqyvxnwjyfrhh54pdql20ab3iifqpp9i5mi85";
          }))
          ++ (lib.optional (!lib.versionAtLeast version "6.0") (fetchpatch {
            name   = "import-for-python-print.patch";
            url    = "https://github.com/apple/foundationdb/commit/ded17c6cd667f39699cf663c0e87fe01e996c153.patch";
            sha256 = "11y434w68cpk7shs2r22hyrpcrqi8vx02cw7v5x79qxvnmdxv2an";
          }))
          ;

        postPatch = ''
          # note: this does not do anything for 6.0+
          substituteInPlace ./build/scver.mk \
            --subst-var-by NIXOS_FDB_VERSION_ID "${rev}" \
            --subst-var-by NIXOS_FDB_SCBRANCH   "${branch}"

          substituteInPlace ./Makefile \
            --replace 'shell which ccache' 'shell true' \
            --replace -Werror ""

          substituteInPlace ./Makefile \
            --replace libstdc++_pic libstdc++

          substituteInPlace ./build/link-validate.sh \
            --replace 'exit 1' '#exit 1'

          patchShebangs .
        '' + lib.optionalString (lib.versionAtLeast version "6.0") ''
          substituteInPlace ./Makefile \
            --replace 'TLS_LIBS +=' '#TLS_LIBS +=' \
            --replace 'LDFLAGS :=' 'LDFLAGS := -ltls -lssl -lcrypto'
        '';

        separateDebugInfo = true;
        enableParallelBuilding = true;

        makeFlags = [ "all" "fdb_java" "fdb_python" ]
          # Don't compile FDBLibTLS if we don't need it in 6.0 or later;
          # it gets statically linked in
          ++ lib.optional (!lib.versionAtLeast version "6.0") [ "fdb_c" ]
          # Needed environment overrides
          ++ [ "KVRELEASE=1"
               "NOSTRIP=1"
             ] ++ lib.optional officialRelease [ "RELEASE=true" ];

        # on 6.0 and later, we can specify all this information manually
        configurePhase = lib.optionalString (lib.versionAtLeast version "6.0") ''
          export SOURCE_CONTROL=GIT
          export SCBRANCH="${branch}"
          export VERSION_ID="${rev}"
        '';

        installPhase = ''
          mkdir -vp $out/{bin,libexec/plugins} $lib/{lib,share/java} $dev/include/foundationdb

        '' + lib.optionalString (!lib.versionAtLeast version "6.0") ''
          # we only copy the TLS library on < 6.0, since it's compiled-in otherwise
          cp -v ./lib/libFDBLibTLS.so $out/libexec/plugins/FDBLibTLS.so
        '' + ''

          # C API
          cp -v ./lib/libfdb_c.so                           $lib/lib
          cp -v ./bindings/c/foundationdb/fdb_c.h           $dev/include/foundationdb
          cp -v ./bindings/c/foundationdb/fdb_c_options.g.h $dev/include/foundationdb
          cp -v ./fdbclient/vexillographer/fdb.options      $dev/include/foundationdb

          # java
          cp -v ./bindings/java/foundationdb-client.jar     $lib/share/java/fdb-java.jar

          # python
          cp LICENSE ./bindings/python
          substitute ./bindings/python/setup.py.in ./bindings/python/setup.py \
            --replace 'VERSION' "${version}"
          rm -f ./bindings/python/setup.py.in
          rm -f ./bindings/python/fdb/*.pth # remove useless files
          rm -f ./bindings/python/*.rst ./bindings/python/*.mk

          cp -R ./bindings/python/                          tmp-pythonsrc/
          tar -zcf $pythonsrc --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/

          # binaries
          for x in fdbbackup fdbcli fdbserver fdbmonitor; do
            cp -v "./bin/$x" $out/bin;
          done

          ln -sfv $out/bin/fdbbackup $out/bin/dr_agent
          ln -sfv $out/bin/fdbbackup $out/bin/fdbrestore
          ln -sfv $out/bin/fdbbackup $out/bin/fdbdr

          ln -sfv $out/bin/fdbbackup $out/libexec/backup_agent
        '';

        outputs = [ "out" "lib" "dev" "pythonsrc" ];

        meta = with stdenv.lib; {
          description = "Open source, distributed, transactional key-value store";
          homepage    = https://www.foundationdb.org;
          license     = licenses.asl20;
          platforms   = [ "x86_64-linux" ];
          maintainers = with maintainers; [ thoughtpolice ];
       };
    };

in with builtins; {

  foundationdb51 = makeFdb rec {
    version = "5.1.7";
    branch  = "release-5.1";
    sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";
  };

  foundationdb52 = makeFdb rec {
    version = "5.2.8";
    branch  = "release-5.2";
    sha256  = "1kbmmhk2m9486r4kyjlc7bb3wd50204i0p6dxcmvl6pbp1bs0wlb";
  };

  foundationdb60 = makeFdb rec {
    version = "6.0.18";
    branch  = "release-6.0";
    sha256  = "0q1mscailad0z7zf1nypv4g7gx3damfp45nf8nzyq47nsw5gz69p";
  };
}
