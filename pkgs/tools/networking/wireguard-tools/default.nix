{ stdenv, lib, fetchzip, libmnl, useSystemd ? stdenv.isLinux }:

let
  inherit (lib) optional optionalString;
in

stdenv.mkDerivation rec {
  name = "wireguard-tools-${version}";
  version = "0.0.20180514";

  src = fetchzip {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "15z0s1i8qyq1fpw8j6rky53ffrpp3f49zn1022jwdslk4g0ncaaj";
  };

  preConfigure = "cd src";

  buildInputs = optional stdenv.isLinux libmnl;

  enableParallelBuilding = true;

  makeFlags = [
    "WITH_BASHCOMPLETION=yes"
    "WITH_WGQUICK=yes"
    "WITH_SYSTEMDUNITS=${if useSystemd then "yes" else "no"}"
    "DESTDIR=$(out)"
    "PREFIX=/"
    "-C" "tools"
  ];

  buildPhase = "make tools";

  postInstall = optionalString useSystemd ''
    substituteInPlace $out/lib/systemd/system/wg-quick@.service \
      --replace /usr/bin $out/bin
  '';

  meta = with stdenv.lib; {
    homepage     = https://www.wireguard.com/;
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    description  = " Tools for the WireGuard secure network tunnel";
    maintainers  = with maintainers; [ ericsagnes mic92 zx2c4 ];
    license      = licenses.gpl2;
    platforms    = platforms.unix;
  };
}
