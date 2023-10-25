{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tcolorpy";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NUlDEMvd6l2GJ9tIXC3zo/8Ji7t0oV0GNVP9UF106yo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tcolorpy";
    description = "A library to apply true color for terminal text";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
