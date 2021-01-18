{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "spirv-cross";
  version = "2020-09-17";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = version;
    sha256 = "03agx9f7klw96isfdz3xsw47308qxmgs24nsz7j9kx3f337fn435";
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${version}";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
