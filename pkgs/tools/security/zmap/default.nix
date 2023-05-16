{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libjson, json_c, gengetopt, flex, byacc, gmp
<<<<<<< HEAD
, libpcap, libunistring
=======
, libpcap
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "zmap";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-OJZKcnsuBi3z/AI05RMBitgn01bhVTqx2jFYJLuIJk4=";
  };

  cmakeFlags = [ "-DRESPECT_INSTALL_PREFIX_CONFIG=ON" ];

  nativeBuildInputs = [ cmake pkg-config gengetopt flex byacc ];
  buildInputs = [ libjson json_c gmp libpcap libunistring ];
=======
    sha256 = "0yaahaiawkjk020hvsb8pndbrk8k10wxkfba1irp12a4sj6rywcs";
  };

  patches = [
    # fix build with json-c 0.14 https://github.com/zmap/zmap/pull/609
    ./cmake-json-0.14-fix.patch
  ];

  cmakeFlags = [ "-DRESPECT_INSTALL_PREFIX_CONFIG=ON" ];
  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [ cmake pkg-config gengetopt flex byacc ];
  buildInputs = [ libjson json_c gmp libpcap ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "man" ];

  meta = with lib; {
    homepage = "https://zmap.io/";
    license = licenses.asl20;
    description = "Fast single packet network scanner designed for Internet-wide network surveys";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
