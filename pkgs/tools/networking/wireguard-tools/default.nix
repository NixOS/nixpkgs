{ lib
, stdenv
, fetchzip
, nixosTests
, iptables
, iproute2
, makeWrapper
, openresolv
, procps
}:

stdenv.mkDerivation rec {
  pname = "wireguard-tools";
  version = "1.0.20210914";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${version}.tar.xz";
    sha256 = "sha256-eGGkTVdPPTWK6iEyowW11F4ywRhd+0IXJTZCqY3OZws=";
  };

  outputs = [ "out" "man" ];

  sourceRoot = "source/src";

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
    "WITH_BASHCOMPLETION=yes"
    "WITH_SYSTEMDUNITS=yes"
    "WITH_WGQUICK=yes"
  ];

  postFixup = ''
    substituteInPlace $out/lib/systemd/system/wg-quick@.service \
      --replace /usr/bin $out/bin
  '' + lib.optionalString stdenv.isLinux ''
    for f in $out/bin/*; do
      # allow users to provide their own resolvconf implementation, e.g. the one provided by systemd-resolved
      wrapProgram $f \
        --prefix PATH : ${lib.makeBinPath [ procps iproute2 iptables ]} \
        --suffix PATH : ${lib.makeBinPath [ openresolv ]}
    done
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = nixosTests.wireguard;
  };

  meta = with lib; {
    description = "Tools for the WireGuard secure network tunnel";
    longDescription = ''
      Supplies the main userspace tooling for using and configuring WireGuard tunnels, including the wg(8) and wg-quick(8) utilities.
      - wg : the configuration utility for getting and setting the configuration of WireGuard tunnel interfaces. The interfaces
        themselves can be added and removed using ip-link(8) and their IP addresses and routing tables can be set using ip-address(8)
        and ip-route(8). The wg utility provides a series of sub-commands for changing WireGuard-specific aspects of WireGuard interfaces.
      - wg-quick : an extremely simple script for easily bringing up a WireGuard interface, suitable for a few common use cases.
    '';
    downloadPage = "https://git.zx2c4.com/wireguard-tools/refs/";
    homepage = "https://www.wireguard.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes zx2c4 globin ma27 d-xo ];
    platforms = platforms.unix;
  };
}
