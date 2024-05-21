{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, buildPackages
, cargo
, lzo
, openssl
, pkg-config
, ronn
, rustc
, zlib
}:

let
  pname = "zerotierone";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-YWcqALUB3ZEukL4er2FKcyNdEbuaf//QU5hRbKAfxDA=";
  };

in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
      "rustfsm-0.1.0" = "sha256-q7J9QgN67iuoNhQC8SDVzUkjCNRXGiNCkE8OsQc5+oI=";
    };
  };
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  preConfigure = ''
    cmp ./Cargo.lock ./rustybits/Cargo.lock || {
      echo 1>&2 "Please make sure that the derivation's Cargo.lock is identical to ./rustybits/Cargo.lock!"
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
    platforms = platforms.linux;
  };
}
