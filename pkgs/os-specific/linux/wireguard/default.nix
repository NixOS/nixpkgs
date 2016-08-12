{ stdenv, fetchgit, libmnl, kernel ? null }:

# module requires Linux >= 4.1 https://www.wireguard.io/install/#kernel-requirements
assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "4.1";

let
  name = "wireguard-unstable-${version}";

  version = "2016-07-22";

  src = fetchgit {
    url    = "https://git.zx2c4.com/WireGuard";
    rev    = "8e8bf6f848c324603827c0e57f0856d5866ac32d";
    sha256 = "11qrf9fxm6mkwjnjq7dgbisdric5w22cyfkqc6zx9fla2dz99mxk";
  };

  meta = with stdenv.lib; {
    homepage    = https://www.wireguard.io/;
    description = "Fast, modern, secure VPN tunnel";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
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
