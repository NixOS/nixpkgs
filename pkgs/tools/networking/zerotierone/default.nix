{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchurl

, buildPackages
, iproute2
, lzo
, openssl
, pkg-config
, ronn
, zlib
}:

let
  pname = "zerotierone";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-2lxXgQArHTFCuSBbKRSaLka42p2INLDg0z3TZ+J5msc=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = "${src}/zeroidc";
    name = "${pname}-${version}";
    sha256 = "sha256-Q9uBUD5xxo5gcTQTedVqQv+Z7B1TTPWtaTSuWo7WEPM=";
  };
  postPatch = "cp ${src}/zeroidc/Cargo.lock Cargo.lock";

  preConfigure = ''
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
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];
  buildInputs = [
    iproute2
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

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz danielfullmer ];
    platforms = platforms.all;
  };
}
