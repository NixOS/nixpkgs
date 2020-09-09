{ stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "spirv-cross";
  version = "2020-06-29";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = version;
    sha256 = "0mnccmhlqmpdx92v495z39i07hbvjwdr5n4zbarlrr1d7rm99lx4";
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with stdenv.lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
