{ stdenv, fetchurl, libmnl, kernel ? null }:

# module requires Linux >= 4.1 https://www.wireguard.io/install/#kernel-requirements
assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "4.1";
# module is incompatible with the PaX constification plugin
assert kernel != null -> !(kernel.features.grsecurity or false);

let
  name = "wireguard-unstable-${version}";

  version = "2016-10-25";

  src = fetchurl {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-0.0.20161025.tar.xz";
    sha256 = "09rhap3dzb8rcq1a1af9inf1qz7161yghafbgpbnd9dg016vhgs3";
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
