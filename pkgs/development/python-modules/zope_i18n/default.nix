{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.i18n";
  version = "4.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "229de41f751dae36b1ef9fa284bc548ef40169234bf0d2199e41581e16304621";
  };

  propagatedBuildInputs = [ pytz zope_component ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.i18n;
    description = "Zope Internationalization Support";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
    broken = true;
  };

}
