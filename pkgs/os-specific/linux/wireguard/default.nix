{ stdenv, fetchurl, libmnl, kernel ? null }:

# module requires Linux >= 4.1 https://www.wireguard.io/install/#kernel-requirements
assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "4.1";

let
  name = "wireguard-experimental-${version}";

  version = "0.0.20161129";

  src = fetchurl {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-${version}.tar.xz";
    sha256 = "1dyik704aixq38n71alpr4r8dxh7ipy7mgwbbccipsdadbjy7p3v";
  };

  meta = with stdenv.lib; {
    homepage     = https://www.wireguard.io/;
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    description  = "Fast, modern, secure VPN tunnel";
    maintainers  = with maintainers; [ ericsagnes ];
    license      = licenses.gpl2;
    platforms    = platforms.linux;
  };

  module = stdenv.mkDerivation {
    inherit src meta name;

    preConfigure = ''
      cd src
      sed -i '/depmod/,+1d' Makefile
    '';

    hardeningDisable = [ "pic" ];

    KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    INSTALL_MOD_PATH = "\${out}";

    buildPhase = "make module";
  };

  tools = stdenv.mkDerivation {
    inherit src meta name;

    preConfigure = "cd src";

    buildInputs = [ libmnl ];

    makeFlags = [
      "DESTDIR=$(out)"
      "PREFIX=/"
      "-C" "tools"
    ];

    buildPhase = "make tools";
  };

in if kernel == null
   then tools
   else module
