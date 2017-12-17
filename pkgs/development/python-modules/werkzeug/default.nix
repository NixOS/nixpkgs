{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous
, pytest, requests, glibcLocales }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Werkzeug";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lxbwi9qwlqcbp3c5zfg5d52isj57ncwlspv2d0q41d5k3yfaik2";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ itsdangerous ];
  buildInputs = [ pytest requests glibcLocales ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://www.palletsprojects.com/p/werkzeug/;
    description = "The comprehensive WSGI web application library";
    license = licenses.bsd3;
  };
}
