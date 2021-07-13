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
  version = "0.0.26";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "842bc03c354d8f952436109264db6cd9146f26cee281d1540d5d7c3aa7371bcc";
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
    license = licenses.gpl3Only;
    maintainers = [ maintainers.marsam ];
  };
}
