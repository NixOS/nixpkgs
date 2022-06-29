# https://github.com/meerk40t/svgelements
{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, numpy
, scipy
}:

buildPythonPackage rec {
  version = "1.6.12"; # not quite!
  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = "svgelements";
    rev = "761bb315a6c12a8fcea990276570780a07fc492f";
    sha256 = "sha256-DQU+88Twt6J2TLa745kgS9UKNcYxLpH+ti8uxymS4Rw=";
  };

  pname = "svgelements";

  propagatedBuildInputs = [ numpy scipy ];

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "svgelements does high fidelity SVG parsing and geometric rendering.";
    homepage = "https://github.com/meerk40t/svgelements";
    platforms = platforms.unix;
    maintainers = with maintainers; [rrix];
    license = with licenses; [ mit ];
  };
}
