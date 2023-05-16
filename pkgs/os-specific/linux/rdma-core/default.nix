<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, docutils
, pandoc, ethtool, iproute2, libnl, udev, python3, perl
} :


stdenv.mkDerivation rec {
  pname = "rdma-core";
  version = "45.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
<<<<<<< HEAD
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
=======
    rev = "v${version}";
    sha256 = "sha256-GjR/gFC7fkcLyl8FwTWbQ+jpJTFRqjExjulXwrsRlDY=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake pkg-config pandoc docutils python3 ];
  buildInputs = [ libnl ethtool iproute2 udev perl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  meta = {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
=======
  meta = with lib; {
    description = "RDMA Core Userspace Libraries and Daemons";
    homepage = "https://github.com/linux-rdma/rdma-core";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
