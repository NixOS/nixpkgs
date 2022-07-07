{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "pipectl";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+o5hIDtDAh4r+AKCUhueQ3GBYf2sZtMATGX73Qg+tbo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = licenses.gpl3;
    description = "a simple named pipe management utility";
    maintainers = with maintainers; [ synthetica ];
  };
}
