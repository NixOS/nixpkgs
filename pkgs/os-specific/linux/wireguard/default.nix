{ stdenv, fetchgit, libmnl, kernel }:

stdenv.mkDerivation rec {
  name = "wireguard-${version}";
  version = "20160708";

  src = fetchgit {
    url    = "https://git.zx2c4.com/WireGuard";
    rev    = "dcc2583fe0618931e51aedaeeddde356d123acb2";
    sha256 = "1ciyjpp8c3fv95y1cypk9qyqynp8cqyh2676afq2hd33110d37ni";
  };

  preConfigure = ''
    cd src
    sed -i /depmod/d Makefile
  '';
  
  buildInputs = [ libmnl ];

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  makeFlags = [ 
    "DESTDIR=$(out)" 
    "PREFIX=/"
    "INSTALL_MOD_PATH=$(out)" 
  ];

  meta = with stdenv.lib; {
    homepage    = https://www.wireguard.io/;
    description = "Fast, modern, secure VPN tunnel";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
  };
}
