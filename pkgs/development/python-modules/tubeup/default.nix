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
  version = "0.0.30";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xN3H3l4ANT7/tXg+oGScvE0Atf6h9CVbODaWybe8a9o=";
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
