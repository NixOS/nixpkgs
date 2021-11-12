{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, docutils
, pandoc, ethtool, iproute2, libnl, udev, python3, perl
} :


stdenv.mkDerivation rec {
  pname = "rdma-core";
  version = "37.1";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "19s59id4m0zkkm4hqa36f2xnah4rs4z207kxzn4zdg2x1d06j9jg";
  };

  nativeBuildInputs = [ cmake pkg-config pandoc docutils ];
  buildInputs = [ libnl ethtool iproute2 udev python3 perl ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
  ];

  postPatch = ''
    substituteInPlace srp_daemon/srp_daemon.sh.in \
      --replace /bin/rm rm
  '';

  postInstall = ''
    # cmake script is buggy, move file manually
    mkdir -p $out/${perl.libPrefix}
    mv $out/share/perl5/* $out/${perl.libPrefix}
  '';

  postFixup = ''
    for pls in $out/bin/{ibfindnodesusing.pl,ibidsverify.pl}; do
      echo "wrapping $pls"
      substituteInPlace $pls --replace \
        "${perl}/bin/perl" "${perl}/bin/perl -I $out/${perl.libPrefix}"
    done
  '';

  meta = with lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
