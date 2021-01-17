{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libjson, json_c, gengetopt, flex, byacc, gmp
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "zmap";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "v${version}";
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
