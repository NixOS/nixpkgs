{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hypothesis
, numpy
, pandas
, psycopg2
, pymysql
, python-dateutil
, pytz
, pyyaml
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "siuba";
  version = "0.4.2";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "machow";
    repo = "siuba";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q2nkK51bmIO2OcBuWu+u7yB8UmaqiZJXpuxXcytTlUY=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    psycopg2
    pymysql
    python-dateutil
    pytz
    pyyaml
    six
    sqlalchemy
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];
  doCheck = false;
  # requires running mysql and postgres instances; see docker-compose.yml

  pythonImportsCheck = [
    "siuba"
    "siuba.data"
  ];

  meta = with lib; {
    description = "Use dplyr-like syntax with pandas and SQL";
    homepage = "https://siuba.org";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
