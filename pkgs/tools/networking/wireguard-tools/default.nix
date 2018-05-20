{ stdenv, lib, fetchzip, libmnl, useSystemd ? stdenv.isLinux }:

let
  inherit (lib) optional optionalString;
in

stdenv.mkDerivation rec {
  name = "wireguard-tools-${version}";
  version = "0.0.20180519";

  src = fetchzip {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "0pd04ia0wcm0f6di4gx5kflccc5j35d72j38l8jqpj8vinl6l070";
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
