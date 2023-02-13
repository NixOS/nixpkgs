{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "0.35.2";
  format = "wheel";

  src = python3.pkgs.fetchPypi {
    pname = "cloudsmith_cli";
    inherit format version;
    hash = "sha256-+M4CPveS9dltMI291Atm84T/cf4dPOO3wPvPI15E73Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-configfile
    click-didyoumean
    click-spinner
    cloudsmith-api
    colorama
    future
    requests
    requests-toolbelt
    semver
    simplejson
    six
    setuptools # needs pkg_resources
  ];

  # Wheels have no tests
  doCheck = false;

  pythonImportsCheck = [
    "cloudsmith_cli"
  ];

  meta = with lib; {
    homepage = "https://help.cloudsmith.io/docs/cli/";
    description = "Cloudsmith Command Line Interface";
    changelog = "https://github.com/cloudsmith-io/cloudsmith-cli/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.asl20;
    platforms = with platforms; unix;
  };
}
