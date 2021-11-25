{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, yt-dlp
, docopt
, isPy27
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "0.0.27";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "77affb4105fc319d82c56aa5706151a4976b8b504dd252fe3db01443e27cba50";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docopt==0.6.2" "docopt" \
      --replace "internetarchive==2.0.3" "internetarchive"
  '';

  propagatedBuildInputs = [ internetarchive docopt yt-dlp ];

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
