{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "spirv-cross";
  version = "2021-01-15";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = version;
    sha256 = "/9/Owt7XcdOjujWZnaG1Q7FlywvsRo8/l8/CouS48Vk=";
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
