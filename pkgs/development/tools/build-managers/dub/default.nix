{ stdenv, fetchFromGitHub, curl, dmd, libevent, rsync }:

stdenv.mkDerivation rec {
  name = "dub-${version}";
  version = "1.13.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "dub";
    rev = "v${version}";
    sha256 = "1wd5pdnbaafj33bbg188w0iz28ps4cyjangb12g2s9dyic29zjqv";
  };

  postUnpack = ''
      patchShebangs .
  '';

  # Can be removed with https://github.com/dlang/dub/pull/1368
  dubvar = "\\$DUB";
  postPatch = ''
      substituteInPlace test/fetchzip.sh \
          --replace "dub remove" "\"${dubvar}\" remove"
  '';

  nativeBuildInputs = [ dmd libevent rsync ];
  buildInputs = [ curl ];

  buildPhase = ''
    export DMD=${dmd.out}/bin/dmd
    ./build.sh
  '';

  doCheck = true;

  checkPhase = ''
    export DUB=$NIX_BUILD_TOP/source/bin/dub
    export PATH=$PATH:$NIX_BUILD_TOP/source/bin/
    export DC=${dmd.out}/bin/dmd
    export HOME=$TMP

    rm -rf test/issue502-root-import
    rm test/issue990-download-optional-selected.sh
    rm test/timeout.sh
    rm test/issue674-concurrent-dub.sh
    rm test/issue672-upgrade-optional.sh
    rm test/issue1574-addcommand.sh
    rm test/issue1524-maven-upgrade-dependency-tree.sh
    rm test/issue1416-maven-repo-pkg-supplier.sh
    rm test/issue1037-better-dependency-messages.sh
    rm test/interactive-remove.sh
    rm test/fetchzip.sh
    rm test/feat663-search.sh
    rm test/ddox.sh
    rm test/0-init-multi.sh
    rm test/0-init-multi-json.sh

    ./test/run-unittest.sh
  '';

  installPhase = ''
    mkdir $out
    mkdir $out/bin
    cp bin/dub $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Package and build manager for D applications and libraries";
    homepage = http://code.dlang.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ThomasMader ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}

