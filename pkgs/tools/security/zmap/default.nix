{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libjson, json_c, gengetopt, flex, byacc, gmp
, libpcap, libunistring
}:

stdenv.mkDerivation rec {
  pname = "zmap";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OJZKcnsuBi3z/AI05RMBitgn01bhVTqx2jFYJLuIJk4=";
  };

  cmakeFlags = [ "-DRESPECT_INSTALL_PREFIX_CONFIG=ON" ];

  nativeBuildInputs = [ cmake pkg-config gengetopt flex byacc ];
  buildInputs = [ libjson json_c gmp libpcap libunistring ];

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
