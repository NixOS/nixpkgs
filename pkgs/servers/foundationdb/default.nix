{ stdenv, fetchurl, fetchFromGitHub
, which, findutils, m4, gawk
, python, openjdk, mono58, libressl_2_6
, boost16x
}:

let
  makeFdb =
    { version
    , branch
    , rev, sha256

    # fdb 6.0+ support boost 1.6x+, so default to it
    , boost ? boost16x
    }: stdenv.mkDerivation rec {
        name = "foundationdb-${version}";
        inherit version;

        src = fetchFromGitHub {
          owner = "apple";
          repo  = "foundationdb";
          inherit rev sha256;
        };

        nativeBuildInputs = [ gawk which m4 findutils mono58 ];
        buildInputs = [ python openjdk libressl_2_6 boost ];

        patches =
          [ ./fix-scm-version.patch
            ./ldflags.patch
          ];

        postPatch = ''
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
        '';

        enableParallelBuilding = true;
        makeFlags = [ "all" "fdb_c" "fdb_java" "KVRELEASE=1" ];

        configurePhase = ":";
        installPhase = ''
          mkdir -vp $out/{bin,libexec/plugins} $lib/{lib,share/java} $dev/include/foundationdb

          cp -v ./lib/libfdb_c.so     $lib/lib
          cp -v ./lib/libFDBLibTLS.so $out/libexec/plugins/FDBLibTLS.so

          cp -v ./bindings/c/foundationdb/fdb_c.h           $dev/include/foundationdb
          cp -v ./bindings/c/foundationdb/fdb_c_options.g.h $dev/include/foundationdb

          cp -v ./bindings/java/foundationdb-client.jar     $lib/share/java/fdb-java.jar

          for x in fdbbackup fdbcli fdbserver fdbmonitor; do
            cp -v "./bin/$x" $out/bin;
          done

          ln -sfv $out/bin/fdbbackup $out/bin/dr_agent
          ln -sfv $out/bin/fdbbackup $out/bin/fdbrestore
          ln -sfv $out/bin/fdbbackup $out/bin/fdbdr

          ln -sfv $out/bin/fdbbackup $out/libexec/backup_agent
        '';

        outputs = [ "out" "lib" "dev" ];

        meta = with stdenv.lib; {
          description = "Open source, distributed, transactional key-value store";
          homepage    = https://www.foundationdb.org;
          license     = licenses.asl20;
          platforms   = platforms.linux;
          maintainers = with maintainers; [ thoughtpolice ];
       };
    };

  # hysterical raisins dictate a version of boost this old. however,
  # we luckily do not need to build anything, we just need the header
  # files.
  boost152 = stdenv.mkDerivation rec {
    name = "boost-headers-1.52.0";

    src = fetchurl {
      url = "mirror://sourceforge/boost/boost_1_52_0.tar.bz2";
      sha256 = "14mc7gsnnahdjaxbbslzk79rc0d12h1i681cd3srdwr3fzynlar2";
    };

    configurePhase = ":";
    buildPhase = ":";
    installPhase = "mkdir -p $out/include && cp -R boost $out/include/";
  };

in with builtins; {

  foundationdb51 = makeFdb {
    version = "5.1.7";
    branch  = "release-5.1";
    rev     = "9ad8d02386d4a6a5efecf898df80f2747695c627";
    sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";
    boost   = boost152;
  };

  foundationdb52 = makeFdb rec {
    version = "5.2.0pre1488_${substring 0 8 rev}";
    branch  = "master";
    rev     = "18f345487ed8d90a5c170d813349fa625cf05b4e";
    sha256  = "0mz30fxj6q99cvjzg39s5zm992i6h2l2cb70lc58bdhsz92dz3vc";
    boost   = boost152;
  };

  foundationdb60 = makeFdb rec {
    version = "6.0.0pre1636_${substring 0 8 rev}";
    branch  = "master";
    rev     = "1265a7b6d5e632dd562b3012e70f0727979806bd";
    sha256  = "0z1i5bkbszsbn8cc48rlhr29m54n2s0gq3dln0n7f97gf58mi5yf";
  };

}
