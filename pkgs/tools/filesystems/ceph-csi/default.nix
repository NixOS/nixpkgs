{ stdenv, lib, go, ceph, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ceph-csi";
<<<<<<< HEAD
  version = "3.9.0";
=======
  version = "3.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ go ];
  buildInputs = [ ceph ];

  src = fetchFromGitHub {
    owner = "ceph";
    repo = "ceph-csi";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dKn79EIveepeMzFPweQ3BE3YMCg7mj8EycMbBH8J8PQ=";
=======
    sha256 = "sha256-WN0oASficXdy0Q1BLm37ndGhjcIk1lm38owdk1K/ryY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preConfigure = ''
    export GOCACHE=$(pwd)/.cache
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./_output/* $out/bin
  '';

  meta = with lib; {
    homepage = "https://ceph.com/";
    description = "Container Storage Interface (CSI) driver for Ceph RBD and CephFS";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ johanot ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
