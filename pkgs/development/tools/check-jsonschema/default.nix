{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = version;
    sha256 = "sha256-rPjXua5kITr+I+jqeAO2iGUFVhjkLnQkXlUzRvkXduA=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    identify
    requests
    click
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  meta = with lib; {
    description = "A jsonschema CLI and pre-commit hook";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    license = licenses.apsl20;
    maintainers = with maintainers; [ sudosubin ];
  };
}
