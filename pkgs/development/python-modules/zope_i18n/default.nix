{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.i18n";
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fcc1adb4e5f6188769ab36f6f40a59b567bb5eef91f714584e0dfd0891be5d0";
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
