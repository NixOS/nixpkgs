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
  version = "0.0.33";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RFM0vZeA5PDXf9KzlJ8RTSfM7bz50bpwwszU0gjV1DY=";
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
