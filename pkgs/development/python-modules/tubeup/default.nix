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
  version = "0.0.21";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "326a499be032bee7f7ed921d85abff4b3b4dcd2c3d6ad694f08ef98dbcef19b6";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "docopt==0.6.2" "docopt"
  '';

  propagatedBuildInputs = [ internetarchive docopt youtube-dl ];

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
