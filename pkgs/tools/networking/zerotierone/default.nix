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
  version = "1.8.9";

  owner = "zerotier";
  repo = "ZeroTierOne";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = version;
    sha256 = "sha256-N1VqzjaFJRJiSG4qHqRy4Fs8TlkUqyDoq0/3JQdGwfA=";
  };

  lockFile = fetchurl {
    url = "https://raw.githubusercontent.com/${owner}/${repo}/${version}/zeroidc/Cargo.lock";
    sha256 = "sha256:1lczzz7dhdfagrxa4yr9ivbkdfb9i85cp6q5s7mmwijcfcax3z6b";
  };
in stdenv.mkDerivation {
  pname = "zerotierone";
  inherit version src;

  preConfigure = ''
    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace 'armv5' 'armv6'
  '';

  cargoDeps = rustPlatform.importCargoLock { inherit lockFile; };
  postPatch = "cp ${lockFile} Cargo.lock";

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
    ./zerotier-selftest
  '';

  installPhase = ''
    install -Dt "$out/bin/" zerotier-one
    ln -s $out/bin/zerotier-one $out/bin/zerotier-idtool
    ln -s $out/bin/zerotier-one $out/bin/zerotier-cli

    mkdir -p $man/share/man/man8
    for cmd in zerotier-one.8 zerotier-cli.1 zerotier-idtool.1; do
      cat doc/$cmd | gzip -9n > $man/share/man/man8/$cmd.gz
    done
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
