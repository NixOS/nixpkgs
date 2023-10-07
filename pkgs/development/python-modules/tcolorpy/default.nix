{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tcolorpy";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cCdKeixRfXkvEGBqozMWw2RjliLdzhlMv8GE2Q40LZQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tcolorpy";
    description = "A library to apply true color for terminal text";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
