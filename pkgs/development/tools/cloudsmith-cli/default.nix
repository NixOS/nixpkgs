{ python3
, lib
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "0.31.1";

  format = "wheel";

  src = python3.pkgs.fetchPypi {
    pname = "cloudsmith_cli";
    inherit format version;
    sha256 = "sha256-r8h0fHePZoqy/oFOedkwAke0b+Huasuv+sWcL92EZ+k=";
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

  meta = {
    homepage = "https://help.cloudsmith.io/docs/cli/";
    description = "Cloudsmith Command Line Interface";
    maintainers = with lib.maintainers; [ jtojnar ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
