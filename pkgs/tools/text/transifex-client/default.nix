{ stdenv, buildPythonApplication, fetchPypi
, python-slugify, requests, urllib3, six, setuptools }:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.13.9";

  propagatedBuildInputs = [
    urllib3 requests python-slugify six setuptools
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lgd77vrddvyn8afkxr7a7hblmp4k5sr0i9i1032xdih2bipdd9f";
  };

  prePatch = ''
    substituteInPlace requirements.txt --replace "urllib3<1.24" "urllib3>=1.24" \
      --replace "six==1.11.0" "six>=1.11.0" \
      --replace "python-slugify<2.0.0" "python-slugify>2.0.0"
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
