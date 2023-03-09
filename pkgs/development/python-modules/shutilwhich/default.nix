{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "shutilwhich";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = pname;
    rev = version;
    sha256 = "05fwcjn86w8wprck04iv1zccfi39skdf0lhwpb4b9gpvklyc9mj0";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest -rs
  '';

  meta = with lib; {
    description = "Backport of shutil.which";
    license = licenses.psfl;
    homepage = "https://github.com/mbr/shutilwhich";
    maintainers = with maintainers; [ multun ];
  };
}
