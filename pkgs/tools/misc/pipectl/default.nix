{ stdenv
, lib
, fetchFromGitHub
, cmake
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "pipectl";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dWRem9VHzMwVo+ahUagZB2r4Ag8PyBef5X41vVpZcAc=";
  };

  nativeBuildInputs = [ cmake scdoc ];

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = licenses.gpl3;
    description = "a simple named pipe management utility";
    maintainers = with maintainers; [ synthetica ];
  };
}
