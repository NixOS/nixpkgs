{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "1.2.3";
  format = "wheel";

  src = fetchPypi {
    pname = "cloudsmith_cli";
    inherit format version;
    hash = "sha256-MIoRLWk6G8uchQlGOYOsg3XliZ1wMrYSOhAEQrus+fQ=";
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
    mainProgram = "cloudsmith";
    changelog = "https://github.com/cloudsmith-io/cloudsmith-cli/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
    platforms = with platforms; unix;
  };
}
