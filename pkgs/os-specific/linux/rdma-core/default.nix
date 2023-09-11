{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, docutils
, pandoc
, ethtool
, iproute2
, libnl
, udev
, python3
, perl
} :

stdenv.mkDerivation (finalAttrs: {
  pname = "rdma-core";
  version = "47.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R+qgHDu9GRwT5ic1DCDlYe1Xb4hqi8pgitKq9iBBQNQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    docutils
    pandoc
    pkg-config
    python3
  ];

  buildInputs = [
    ethtool
    iproute2
    libnl
    perl
    udev
  ];

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

  meta = {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
