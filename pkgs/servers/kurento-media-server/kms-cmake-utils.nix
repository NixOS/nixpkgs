{ stdenv, kurentoPackages, cmake }:

stdenv.mkDerivation {
  pname = "kms-cmake-utils";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kms-cmake-utils";
    sha256 = "1m8p1m5wwjp34xzns6vfhm4hkjmgnq0nsy85zx4bczyakhf505vd";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "CMake common files used to build all Kurento C/C++ projects";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
