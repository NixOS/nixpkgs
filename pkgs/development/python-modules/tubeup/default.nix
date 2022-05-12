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
    sha256 = "c4ddc7de5e00353effb5783ea0649cbc4d00b5fea1f4255b383696c9b7bc6bda";
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
