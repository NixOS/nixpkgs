{ stdenv, fetchurl, fetchFromGitHub
, which, findutils, m4, gawk, python, openjdk, mono58, libressl_2_6
}:

let
  version = "5.1.7";
  branch  = "release-5.1";
  rev     = "9ad8d02386d4a6a5efecf898df80f2747695c627";
  sha256  = "1rc472ih24f9s5g3xmnlp3v62w206ny0pvvw02bzpix2sdrpbp06";

  # hysterical raisins dictate a version of boost this old. however,
  # we luckily do not need to build anything, we just need the header
  # files.
  boost152 = stdenv.mkDerivation rec {
    name = "boost-headers-1.52.0";

    src = fetchurl {
      url = "mirror://sourceforge/boost/boost_1_52_0.tar.bz2";
      sha256 = "14mc7gsnnahdjaxbbslzk79rc0d12h1i681cd3srdwr3fzynlar2";
    };

    buildPhase = ":";
    configurePhase = ":";
    installPhase = ''
      mkdir -p $out/include/
      cp -R boost $out/include/
    '';
  };

in stdenv.mkDerivation rec {
  name = "foundationdb-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "apple";
    repo  = "foundationdb";
    inherit rev sha256;
  };

  nativeBuildInputs = [ gawk which m4 findutils boost152 mono58 ];
  buildInputs = [ python openjdk libressl_2_6 ];

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
  makeFlags = [ "all" "fdb_c" "KVRELEASE=1" ];

  configurePhase = ":";
  installPhase = ''
    mkdir -vp $out/{bin,libexec/plugins} $lib/lib $dev/include/foundationdb

    cp -v ./lib/libfdb_c.so     $lib/lib
    cp -v ./lib/libFDBLibTLS.so $out/libexec/plugins/FDBLibTLS.so

    cp -v ./bindings/c/foundationdb/fdb_c.h           $dev/include/foundationdb
    cp -v ./bindings/c/foundationdb/fdb_c_options.g.h $dev/include/foundationdb

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
}
