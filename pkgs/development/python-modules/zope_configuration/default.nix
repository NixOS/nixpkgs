{ stdenv
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_schema
, isPy3k
}:

buildPythonPackage rec {
  pname = "zope.configuration";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ddd162b7b9379c0f5cc060cbf2af44133396b7d26eaee9c7cf6e196d87e9aeb3";
  };

  propagatedBuildInputs = [ zope_i18nmessageid zope_schema ];

  # Trouble with implicit namespace packages on Python3
  # see https://github.com/pypa/setuptools/issues/912
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = https://github.com/zopefoundation/zope.configuration;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
