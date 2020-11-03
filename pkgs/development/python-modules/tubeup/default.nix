{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, youtube-dl
, docopt
, isPy27
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "0.0.20";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bf4004629b8427173c8259e1a09065db99135d6cc390b70a8a67b52a34a3f67";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "docopt==0.6.2" "docopt"
  '';

  requiredPythonModules = [ internetarchive docopt youtube-dl ];

  pythonImportsCheck = [ "tubeup" ];

  # Tests failing upstream
  doCheck = false;

  meta = with lib; {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    homepage = "https://github.com/bibanon/tubeup";
    license = licenses.gpl3;
    maintainers = [ maintainers.marsam ];
  };
}
