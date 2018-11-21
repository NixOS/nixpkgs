{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.i18n";
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "045nnimmshibcq71yym2d8yrs6wzzhxq5gl7wxjnkpyjm5y0hfkm";
  };

  propagatedBuildInputs = [ pytz zope_component ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18n;
    description = "Zope Internationalization Support";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
