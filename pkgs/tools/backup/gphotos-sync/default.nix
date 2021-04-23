{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gphotos-sync";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "gilesknap";
    repo = "gphotos-sync";
    rev = version;
    sha256 = "0cfmbrdy6w18hb623rjn0a4hnn3n63jw2jlmgn4a2k1sjqhpx3bf";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    attrs
    exif
    psutil
    pyyaml
    requests_oauthlib
  ];
  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];
  checkPhase = ''
    export HOME=$(mktemp -d)

    # patch to skip all tests that do network access
    cat >>test/test_setup.py <<EOF
    import pytest, requests
    requests.Session.__init__ = lambda *args, **kwargs: pytest.skip("no network access")
    EOF

    pytestCheckPhase
  '';

  meta = with lib; {
    description = "Google Photos and Albums backup with Google Photos Library API";
    homepage    = "https://github.com/gilesknap/gphotos-sync";
    license     = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
