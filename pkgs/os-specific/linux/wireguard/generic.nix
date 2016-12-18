{ stdenv, fetchurl, libmnl, iproute, kernel ? null, version, sha256 }:

# module requires Linux >= 4.1 https://www.wireguard.io/install/#kernel-requirements
assert kernel != null -> stdenv.lib.versionAtLeast kernel.version "4.1";

let
  name = "wireguard-${version}";

  src = fetchurl {
    url    = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    inherit sha256;
  };

  meta = with stdenv.lib; {
    homepage     = https://www.wireguard.io/;
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    description  = "Fast, modern, secure VPN tunnel";
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
    postInstall = ''
      for i in ../contrib/examples/wg-config/*; do
        dest="$out/bin/$(basename $i)"
        install -m755 $i "$dest"
        # avoid wrapper because tool resolve symlink to $0
        sed -i "2iexport PATH=${iproute}/bin:\$PATH" "$dest"
      done
    '';
  };

in if kernel == null
   then tools
   else module
