{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "1.1.1";
  format = "wheel";

  src = fetchPypi {
    pname = "cloudsmith_cli";
    inherit format version;
    hash = "sha256-evwXXGmGa6V2LhgkmX04E5VvdPxeZzvl4F28auXcSng=";
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
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
    platforms = with platforms; unix;
  };
}
