{ stdenv, fetchurl, libmnl, kernel ? null }:

# module requires Linux >= 3.10 https://www.wireguard.io/install/#kernel-requirements
assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "3.10";

let
  name = "wireguard-${version}";

  version = "0.0.20170421";

  src = fetchurl {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "03c82af774224cd171d000ee4a519b5e474cc6842ac04967773cf77b26750000";
  };

  meta = with stdenv.lib; {
    homepage     = https://www.wireguard.io/;
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    description  = "A prerelease of an experimental VPN tunnel which is not to be depended upon for security";
    maintainers  = with maintainers; [ ericsagnes mic92 ];
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

    NIX_CFLAGS = ["-Wno-error=cpp"];

    buildPhase = "make module";
  };

  tools = stdenv.mkDerivation {
    inherit src meta name;

    preConfigure = "cd src";

    buildInputs = [ libmnl ];

    makeFlags = [
      "WITH_BASHCOMPLETION=yes"
      "WITH_WGQUICK=yes"
      "WITH_SYSTEMDUNITS=yes"
      "DESTDIR=$(out)"
      "PREFIX=/"
      "-C" "tools"
    ];

    buildPhase = "make tools";
  };

in if kernel == null
   then tools
   else module
