{ stdenv, fetchFromGitHub, fetchpatch, curl, dmd, libevent, rsync }:

let

  dubBuild = stdenv.mkDerivation rec {
    name = "dubBuild-${version}";
    version = "1.7.2";

    enableParallelBuilding = true;

    src = fetchFromGitHub {
      owner = "dlang";
      repo = "dub";
      rev = "v${version}";
      sha256 = "073ibvgm1gphcqs1yjrav9ryp677nh3b194nxmvicwgvdc0sb6w9";
    };

    postUnpack = ''
        patchShebangs .
    '';

    patches = [
      # TODO Remove with next release which contains https://github.com/dlang/dub/pull/1354
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/dlang/dub/pull/1354.patch";
        sha256 = "01alky8a91qwjmlnfjbrn8kiivwr69f3j4c84cjlxrzfp1ph20ah";
      })
    ];

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
  };

  # Need to test in a fixed-output derivation, otherwise the
  # network tests would fail if sandbox mode is enabled.
  dubUnittests = stdenv.mkDerivation rec {
    name = "dubUnittests-${version}";
    version = dubBuild.version;

    enableParallelBuilding = dubBuild.enableParallelBuilding;
    preferLocalBuild = true;
    inputString = dubBuild.outPath;
    outputHashAlgo = "sha256";
    outputHash = builtins.hashString "sha256" inputString;

    src = dubBuild.src;
    
    patches = dubBuild.patches;

    postUnpack = dubBuild.postUnpack;
    postPatch = dubBuild.postPatch;

    nativeBuildInputs = dubBuild.nativeBuildInputs;
    buildInputs = dubBuild.buildInputs;

    buildPhase = ''
      # Can't use dub from dubBuild directly because one unittest 
      # (issue895-local-configuration) needs to generate a config 
      # file under ../etc relative to the dub location.
      cp ${dubBuild}/bin/dub bin/
      export DUB=$NIX_BUILD_TOP/source/bin/dub
      export DC=${dmd.out}/bin/dmd
      export HOME=$TMP
      ./test/run-unittest.sh
    '';

    installPhase = ''
        echo -n $inputString > $out
    '';
  };

in

stdenv.mkDerivation rec {
  inherit dubUnittests;
  name = "dub-${dubBuild.version}";
  phases = "installPhase";
  buildInputs = dubBuild.buildInputs;

  installPhase = ''
    mkdir $out
    cp -r --symbolic-link ${dubBuild}/* $out/
  '';

  meta = dubBuild.meta;
}

