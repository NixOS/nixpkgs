{ stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "spirv-cross";
  version = "2020-05-19";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = version;
    sha256 = "0zyijp9zx9wbd4i5lwjap7n793iz6yjkf27la60dsffxl75yy9pd";
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
