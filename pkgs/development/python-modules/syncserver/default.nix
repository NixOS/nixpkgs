{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, unittest2
, cornice
, gunicorn
, pyramid
, requests
, simplejson
, sqlalchemy
, mozsvc
, tokenserver
, serversyncstorage
, configparser
}:

buildPythonPackage rec {
  pname = "syncserver";
  version = "1.8.0";
  disabled = ! isPy27;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncserver";
    rev = version;
    sha256 = "0hxjns9hz7a8r87iqr1yfvny4vwj1rlhwcf8bh7j6lsf92mkmgy8";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [
    cornice gunicorn pyramid requests simplejson sqlalchemy mozsvc tokenserver
    serversyncstorage configparser
  ];

  meta = with stdenv.lib; {
    description = "Run-Your-Own Firefox Sync Server";
    homepage = "https://github.com/mozilla-services/syncserver";
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
