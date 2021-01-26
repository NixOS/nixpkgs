{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, zope_event
, zope_component
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.lifecycleevent";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ec39087cc1524e55557e7d9dc6295eb1b95b09b125e293c0e2dd068574f0aee";
  };

  propagatedBuildInputs = [ zope_event zope_component ];

  # namespace colides with local directory
  doCheck = false;

  # zope uses pep 420 namespaces for python3, doesn't work with nix + python2
  pythonImportsCheck = lib.optionals isPy3k [
    "zope.lifecycleevent"
    "zope.interface"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.lifecycleevent";
    description = "Object life-cycle events";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
