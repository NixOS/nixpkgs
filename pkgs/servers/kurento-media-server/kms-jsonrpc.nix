{ stdenv, kurentoPackages, cmake, pkgconfig, boost }:

stdenv.mkDerivation {
  pname = "kms-jsonrpc";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kms-jsonrpc";
    sha256 = "0fpl5hliphw0vkv9x2s3l099a5scs78vvh06s46fn0xv3lf0wjay";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost kurentoPackages.kmsjsoncpp ];
  cmakeFlagsArray = kurentoPackages.lib.mkCmakeModules [ kurentoPackages.kms-cmake-utils ];

  meta = with stdenv.lib; {
    description = "JsonRPC protocol implementation";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
