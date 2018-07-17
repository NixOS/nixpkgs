{ stdenv, fetchFromGitHub, cmake, pkgconfig, pandoc
, ethtool, nettools, libnl, udev, python, perl
} :

let
  version = "19";

in stdenv.mkDerivation {
  name = "rdma-core-${version}";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "0c01f9yn9sk7wslyrclsi2jvrn4d36bdw4qjbl0vmcv4858wf4bb";
  };

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ libnl ethtool nettools udev python perl ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
  ];

  postPatch = ''
    substituteInPlace providers/rxe/rxe_cfg.in \
      --replace ethtool "${ethtool}/bin/ethtool" \
      --replace ifconfig "${nettools}/bin/ifconfig"
  '';

  meta = with stdenv.lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = https://github.com/linux-rdma/rdma-core;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
