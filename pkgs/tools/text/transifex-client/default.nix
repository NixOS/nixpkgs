{ lib, buildPythonApplication, fetchPypi
, python-slugify, requests, urllib3, six, setuptools, GitPython }:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.14.3";

  propagatedBuildInputs = [
    urllib3 requests python-slugify six setuptools GitPython
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sKol67lRaYPFa7Bg9KNa1rDrNoT9DtUd48NY8jqK1iw=";
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
