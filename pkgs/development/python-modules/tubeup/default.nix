{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, yt-dlp
, docopt
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "0.0.35";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "006aea68bb8d967a7427c58ee7862e3f2481dae667c2bbcfb1a1f2fd80e665d1";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "internetarchive==3.0.2" "internetarchive" \
      --replace "urllib3==1.26.13" "urllib3" \
      --replace "docopt==0.6.2" "docopt"
  '';

  propagatedBuildInputs = [
    internetarchive
    docopt
    urllib3
    yt-dlp
  ];

  pythonImportsCheck = [
    "tubeup"
  ];

  # Tests failing upstream
  doCheck = false;

  meta = with lib; {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    homepage = "https://github.com/bibanon/tubeup";
    changelog = "https://github.com/bibanon/tubeup/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
