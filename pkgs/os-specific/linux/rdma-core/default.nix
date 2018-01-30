{ stdenv, fetchFromGitHub, cmake, pkgconfig
, ethtool, libnl, libudev, python, perl
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
  buildInputs = [ libnl ethtool libudev python perl ];

  postFixup = ''
    substituteInPlace $out/bin/rxe_cfg --replace ethtool "${ethtool}/bin/ethtool"
  '';

  meta = with stdenv.lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = https://github.com/linux-rdma/rdma-core;
    license = licenses.gpl2;
    maintainers = with maintainers; [ markuskowa ];
  };
}

