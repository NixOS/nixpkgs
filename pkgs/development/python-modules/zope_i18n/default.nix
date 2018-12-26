{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.i18n";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14f7339f6d4fed5e94882a7f1b2e40fd90ad00b3c28a7f4353762101395e3304";
  };

  propagatedBuildInputs = [ pytz zope_component ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18n;
    description = "Zope Internationalization Support";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
