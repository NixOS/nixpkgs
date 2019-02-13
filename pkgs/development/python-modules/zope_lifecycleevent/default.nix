{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
, zope_component
}:

buildPythonPackage rec {
  pname = "zope.lifecycleevent";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ec39087cc1524e55557e7d9dc6295eb1b95b09b125e293c0e2dd068574f0aee";
  };

  propagatedBuildInputs = [ zope_event zope_component ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.lifecycleevent;
    description = "Object life-cycle events";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
