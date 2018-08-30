{ stdenv, fetchFromGitHub, curl, dmd, libevent, rsync }:

let

  dubBuild = stdenv.mkDerivation rec {
    name = "dubBuild-${version}";
    version = "1.10.0";

    enableParallelBuilding = true;

    src = fetchFromGitHub {
      owner = "dlang";
      repo = "dub";
      rev = "v${version}";
      sha256 = "02xxpfcjs427jqbwz0vh5vl3bh62ys65zmi9gpa3svzqffyx13n4";
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
  # Disable tests on Darwin for now because they don't work
  # reliably there.
  dubUnittests = if !stdenv.hostPlatform.isDarwin then
    stdenv.mkDerivation rec {
      name = "dubUnittests-${version}";
      version = dubBuild.version;

      enableParallelBuilding = dubBuild.enableParallelBuilding;
      preferLocalBuild = true;
      inputString = dubBuild.outPath;
      outputHashAlgo = "sha256";
      outputHash = builtins.hashString "sha256" inputString;

      src = dubBuild.src;
      
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
        export PATH=$PATH:$NIX_BUILD_TOP/source/bin/
        export DC=${dmd.out}/bin/dmd
        export HOME=$TMP
        ./test/run-unittest.sh
      '';

      installPhase = ''
          echo -n $inputString > $out
      '';
    }
  else
    "";

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

