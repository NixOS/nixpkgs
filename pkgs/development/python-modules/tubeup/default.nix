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
  version = "0.0.25";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1869363eddb85f39c05971d159bb2bf8cafa596acff3b9117635ebebfd1d342";
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
