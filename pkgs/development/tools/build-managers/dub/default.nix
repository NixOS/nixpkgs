{ stdenv, fetchFromGitHub, curl, dmd, libevent, rsync }:

stdenv.mkDerivation rec {
  name = "dub-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "dub";
    rev = "v${version}";
    sha256 = "0kmirx4ijhzirjwdqmnwqhngg38zdaydpvny2p0yj3afqgkj6vq5";
  };

  postPatch = ''
    # Avoid that the version file is overwritten
    substituteInPlace build.sh \
      --replace source/dub/version_.d /dev/null

    substituteInPlace build.sh \
      --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_

    patchShebangs build.sh
    patchShebangs test

    # Remove unittest which is not working for now (upstream already fixed: https://github.com/dlang/dub/issues/1224)
    rm test/interactive-remove.sh

    # Fix test as long as there is no upstream solution. (see https://github.com/dlang/dub/pull/1227)
    substituteInPlace test/issue884-init-defer-file-creation.sh \
      --replace "< /dev/stdin" "<(while :; do sleep 1; done)" \
      --replace "sleep 1" ""
  '';

  nativeBuildInputs = [ dmd libevent rsync ];
  buildInputs = [ curl ];

  buildPhase = ''
    export DMD=${dmd.out}/bin/dmd
    ./build.sh
  '';

  doCheck = false;

  checkPhase = ''
      export DUB=$PWD/bin/dub
      export DC=${dmd.out}/bin/dmd
      export HOME=$TMP
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
    platforms = platforms.unix;
  };
}

