{ lib
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "S3Scanner";
  version = "2.0.2";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RRx2u+PHxcdinemQoekExH2+TU+brGJud7XmeZ3ARc4=";
  };

  propagatedBuildInputs = [
    boto3
  ];

  meta = with lib; {
    description = "Scan for open S3 buckets and dump the contents";
    homepage = "https://github.com/sa7mon/S3Scanner";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
