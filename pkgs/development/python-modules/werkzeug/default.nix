{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous
, pytest, requests, glibcLocales }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Werkzeug";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09mv4cya3lywkn4mi3qrqmjgwiw99kdk03dk912j8da6ny3pnflh";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ itsdangerous ];
  buildInputs = [ pytest requests glibcLocales ];

  meta = with stdenv.lib; {
    homepage = http://werkzeug.pocoo.org/;
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
