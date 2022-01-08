{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "pipectl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wa/SKKNXkl8XxE7XORodoAlrMc2QNGXGPE+/yya209Y=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = licenses.gpl3;
    description = "a simple named pipe management utility";
    maintainers = with maintainers; [ synthetica ];
  };
}
