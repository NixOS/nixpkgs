{ lib, stdenv, fetchFromGitHub, cmake, ninja, cli11, fmt, nlohmann_json, glslang
, python3 }:

let
  cesanta_mongoose_6 = rec {
    pname = "cesanta-mongoose";
    version = "6.18";

    src = fetchFromGitHub {
      owner = "cesanta";
      repo = "mongoose";
      rev = version;
      sha256 = "sha256-7r8/Z27sfs6gHTHYLoGvdNU/zG9LeLDLjyiSfPaF9VI=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "glsl-language-server";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = version;
    sha256 = "sha256-6gXHkCHulPydxQYMCx28HaZfkha36IwfOBuAfMLCW9c=";
  };

  nativeBuildInputs = [ cmake ninja python3 ];

  preConfigure = ''
    mkdir -p externals
    ln -s ${cli11} externals/CLI11
    ln -s ${fmt.src} externals/fmt
    ln -s ${nlohmann_json.src} externals/json
    ln -s ${glslang.src} externals/glslang
    ln -s ${cesanta_mongoose_6.src} externals/mongoose
  '';

  meta = with lib; {
    description = "Language server implementation for GLSL";
    homepage = "https://github.com/svenstaro/glsl-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
