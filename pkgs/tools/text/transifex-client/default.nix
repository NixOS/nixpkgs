{ lib, buildPythonApplication, fetchPypi
, python-slugify, requests, urllib3, six, setuptools, GitPython }:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.14.4";

  propagatedBuildInputs = [
    urllib3 requests python-slugify six setuptools GitPython
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "11dc95cefe90ebf0cef3749c8c7d85b9d389c05bd0e3389bf117685df562bd5c";
  };

  # https://github.com/transifex/transifex-client/issues/323
  prePatch = ''
    substituteInPlace requirements.txt \
      --replace "python-slugify<5.0.0" "python-slugify"
  '';

  # Requires external resources
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.transifex.com/";
    license = licenses.gpl2Only;
    description = "Transifex translation service client";
    maintainers = with maintainers; [ sikmir ];
  };
}
