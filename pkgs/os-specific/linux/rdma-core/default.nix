{ stdenv, fetchFromGitHub, cmake, pkgconfig
, ethtool, nettools, libnl, libudev, python, perl
} :

let
  version = "17.1";

in stdenv.mkDerivation {
  name = "rdma-core-${version}";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "019h5q0szjccdgfk13qy0f2dxd0n1fr407b3qqq1vcmx41w9b6vz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libnl ethtool nettools libudev python perl ];

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

