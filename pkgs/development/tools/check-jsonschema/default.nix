{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = version;
    sha256 = "sha256-9Ejcxr/22rJu8JoC7WspLfzF08elz4TaGagDeV0zIXk=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    identify
    requests
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  pytestFlagsArray = [
    # DeprecationWarning: Accessing jsonschema.draft3_format_checker is deprecated and will be removed in a future release. Instead, use the FORMAT_CHECKER attribute on the corresponding Validator.
    "-W" "ignore::DeprecationWarning"
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
