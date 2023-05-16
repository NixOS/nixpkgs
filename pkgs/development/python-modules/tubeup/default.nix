{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, yt-dlp
, docopt
, pythonOlder
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
, urllib3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "tubeup";
<<<<<<< HEAD
  version = "2023.8.19";
=======
  version = "0.0.35";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-0atpOUJIfXgw/5fi5w2ciAFDMgWmVH4U8d84zwLCRXk=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
=======
    sha256 = "006aea68bb8d967a7427c58ee7862e3f2481dae667c2bbcfb1a1f2fd80e665d1";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "internetarchive==3.0.2" "internetarchive" \
      --replace "urllib3==1.26.13" "urllib3" \
      --replace "docopt==0.6.2" "docopt"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    internetarchive
    docopt
<<<<<<< HEAD
    yt-dlp
  ];

  pythonRelaxDeps = [
    "docopt"
  ];

=======
    urllib3
    yt-dlp
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
