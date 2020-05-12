{ stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "spirv-cross";
  version = "2020-04-03";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = version;
    sha256 = "0489s29kqgq20clxqg22y299yxz23p0yjh87yhka705hm9skx4sa";
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
