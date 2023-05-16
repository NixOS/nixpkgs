{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, buildPackages
, cargo
=======

, buildPackages
, cargo
, iproute2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lzo
, openssl
, pkg-config
, ronn
, rustc
, zlib
}:

let
  pname = "zerotierone";
<<<<<<< HEAD
  version = "1.12.1";
=======
  version = "1.10.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-430wdPrSNohM3sXewusjsW3tbE7EFGISGxABZF21yRc=";
=======
    sha256 = "sha256-mapFKeF+8jMGkxSuHaw5oUdTdSQgAdxEwF/S6iyVLbY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
    };
  };
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  preConfigure = ''
    cmp ./Cargo.lock ./zeroidc/Cargo.lock || {
      echo 1>&2 "Please make sure that the derivation's Cargo.lock is identical to ./zeroidc/Cargo.lock!"
      exit 1
    }

    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace '-march=armv6zk' "" \
      --replace '-mcpu=arm1176jzf-s' ""
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  buildInputs = [
<<<<<<< HEAD
=======
    iproute2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    lzo
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  buildFlags = [ "all" "selftest" ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = ''
    runHook preCheck
    ./zerotier-selftest
    runHook postCheck
  '';

  installFlags = [ "DESTDIR=$$out/upstream" ];

  postInstall = ''
    mv $out/upstream/usr/sbin $out/bin

    mkdir -p $man/share
    mv $out/upstream/usr/share/man $man/share/man

    rm -rf $out/upstream
  '';

  outputs = [ "out" "man" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz danielfullmer ];
<<<<<<< HEAD
    platforms = platforms.linux;
=======
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
