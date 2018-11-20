{ stdenv
, buildPythonPackage
, fetchPypi
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82d7eaa4d831ff1ecdcffcb274f3457e095c0cc86e630bc72009a863c341ab9f";
  };

  propagatedBuildInputs = [ zconfig ];

  # too many deps..
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A daemon process control library and tools for Unix-based systems";
    homepage = https://pypi.python.org/pypi/zdaemon;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
