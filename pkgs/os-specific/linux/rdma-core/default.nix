{ stdenv, fetchFromGitHub, cmake, pkgconfig
, ethtool, nettools, libnl, libudev, python, perl
} :

let
  version = "16.1";

in stdenv.mkDerivation {
  name = "rdma-core-${version}";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "1fixw6hpf732vzlpczx0b2y84jrhgfjr3cljqxky7makzgh2s7ng";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libnl ethtool nettools libudev python perl ];

  postPatch = ''
    substituteInPlace providers/rxe/rxe_cfg.in \
      --replace '@CMAKE_INSTALL_FULL_SHAREDSTATEDIR@' '/run' \
      --replace ethtool "${ethtool}/bin/ethtool" \
      --replace ifconfig "${nettools}/bin/ifconfig"
  '';

  meta = with stdenv.lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = https://github.com/linux-rdma/rdma-core;
    license = licenses.gpl2;
    maintainers = with maintainers; [ markuskowa ];
  };
}

