{ stdenv, fetchFromGitHub, cmake, pkgconfig, docutils
, pandoc, ethtool, iproute, libnl, udev, python, perl
, makeWrapper
} :

let
  version = "31.1";

in stdenv.mkDerivation {
  pname = "rdma-core";
  inherit version;

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${version}";
    sha256 = "1xkmdix6mgv6kjjj6wi844bfddhl0ybalrp5g8pf5izasc43brg7";
  };

  nativeBuildInputs = [ cmake pkgconfig pandoc docutils makeWrapper ];
  buildInputs = [ libnl ethtool iproute udev python perl ];

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
      wrapProgram $pls --prefix PERL5LIB : "$out/${perl.libPrefix}"
    done
  '';

  meta = with stdenv.lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
