{ stdenv
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_schema
, isPy3k
}:

buildPythonPackage rec {
  pname = "zope.configuration";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x9dfqypgympnlm25p9m43xh4qv3p7d75vksv9pzqibrb4cggw5n";
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
