{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "afetch";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "13-CF";
    repo = "afetch";
    rev = "V${version}";
    sha256 = "sha256-bHP3DJpgh89AaCX4c1tQGaZ/PiWjArED1rMdszFUq+U=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Fetch program written in C";
    homepage = "https://github.com/13-CF/afetch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 jk ];
    platforms = platforms.linux;
    mainProgram = "afetch";
  };
}
