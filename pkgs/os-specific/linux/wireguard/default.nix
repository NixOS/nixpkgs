{ stdenv, fetchgit, libmnl, kernel ? null }:

let
  name = "wireguard-${version}";

  version = "20160708";

  src = fetchgit {
    url    = "https://git.zx2c4.com/WireGuard";
    rev    = "dcc2583fe0618931e51aedaeeddde356d123acb2";
    sha256 = "1ciyjpp8c3fv95y1cypk9qyqynp8cqyh2676afq2hd33110d37ni";
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
