{ stdenv, buildPythonApplication, fetchPypi
, python-slugify, requests, urllib3, six, setuptools }:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.13.6";

  propagatedBuildInputs = [
    urllib3 requests python-slugify six setuptools
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y6pprlmkmi7wfqr3k70sb913qa70p3i90q5mravrai7cr32y1w8";
  };

  prePatch = ''
    substituteInPlace requirements.txt --replace "urllib3<1.24" "urllib3>=1.24" \
      --replace "six==1.11.0" "six>=1.11.0" \
      --replace "python-slugify==1.2.6" "python-slugify>=1.2.6"
  '';

  # Requires external resources
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://www.transifex.com/";
    license = licenses.gpl2;
    description = "Transifex translation service client";
    maintainers = [ maintainers.etu ];
  };
}
