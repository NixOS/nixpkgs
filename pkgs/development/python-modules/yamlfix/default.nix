{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pytest-xdist
, pythonOlder, click, ruyaml }:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "0.7.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-qlA6TyLkOuTXCdMnpfkyN/HDIRfB6+0pQ7f0GCsIjL4=";
  };

  propagatedBuildInputs = [ click ruyaml ];

  checkInputs = [ pytestCheckHook pytest-xdist ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python_paths = "."' ""
  '';

  pytestFlagsArray = [ "-n" "$NIX_BUILD_CORES" ];

  pythonImportsCheck = [ "yamlfix" ];

  meta = with lib; {
    description =
      "A simple opinionated yaml formatter that keeps your comments!";
    homepage = "https://github.com/lyz-code/yamlfix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ koozz ];
  };
}
