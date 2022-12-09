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
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-p900bw+BGzyMwH91W9NRfYS1ZUW74YaALwr1Gv9BlvQ=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  preConfigure = ''
    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace '-march=armv6zk' "" \
      --replace '-mcpu=arm1176jzf-s' ""

    # Upstream does not define the cargo settings necessary to use the vendorized rust-jwt version, so it has to be added manually.
    # Can be removed once ZeroTierOne's zeroidc no longer uses a git url in Cargo.toml for jwt
    echo '[source."https://github.com/glimberg/rust-jwt"]
git = "https://github.com/glimberg/rust-jwt"
replace-with = "vendored-sources"' >> ./zeroidc/.cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
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
