{ stdenv
, lib
, fetchFromGitHub
, cmake
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "pipectl";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uBKHGR4kv62EMOIT/K+WbvFtdJ0V5IbsxjwQvhUu9f8=";
  };

  nativeBuildInputs = [ cmake scdoc ];

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = licenses.gpl3;
    description = "Simple named pipe management utility";
    maintainers = with maintainers; [ synthetica ];
    mainProgram = "pipectl";
  };
}
