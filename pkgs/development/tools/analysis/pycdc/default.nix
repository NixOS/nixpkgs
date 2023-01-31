{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "pycdc";
  version = "2023-01-24";

  src = fetchFromGitHub {
    owner = "zrax";
    repo = "pycdc";
    # repo has no tags, use latest commit
    rev = "a6de2209fcfce7374c01e398bd0764c76aa9eb40";
    sha256 = "sha256-4GqtDtUyJ6bFXvdy1LyilW5LGpPzKEIpb+2GzW/ek0g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    python3
  ];

  meta = with lib; {
    description = "python bytecode disassembler and decompiler";
    homepage = "https://github.com/zrax/pycdc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ milahu ];
    platforms = platforms.unix;
  };
}
