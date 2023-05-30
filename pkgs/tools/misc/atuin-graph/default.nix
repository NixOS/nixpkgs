{ lib
, python311
, fetchFromGitHub
}:

with python311.pkgs;

buildPythonApplication rec {
  pname = "atuin-graph";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tieum";
    repo = "atuin-graph";
    rev = "v${version}";
    hash = "sha256-d+mQHU0EMTxcYuNAxl4hwm8htUCRodjY1U8h5n3Sq30=";
  };

  postPatch = ''
    sed -i pyproject.toml \
      -e 's/~=[^"]*//g' \
      -e 's/psycopg2-binary/psycopg2/'
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    blinker
    calplot
    click
    contourpy
    cycler
    flask
    fonttools
    greenlet
    itsdangerous
    jinja2
    kiwisolver
    markupsafe
    matplotlib
    numpy
    packaging
    pandas
    pillow
    psycopg2
    pyparsing
    python-dateutil
    pytz
    six
    sqlalchemy
    typing-extensions
    tzdata
    werkzeug
  ];

  pythonImportsCheck = [ "atuin_graph" ];

  meta = with lib; {
    description = "Activity graph for atuin";
    homepage = "https://github.com/tieum/atuin-graph";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
