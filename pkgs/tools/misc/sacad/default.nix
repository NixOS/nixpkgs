<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, jpegoptim, optipng }:
=======
{ lib, python3Packages, jpegoptim, optipng }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "sacad";
  version = "2.4.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-KLVkyiXjpqskM67W9uPl9aPKc3pYMu0nAfwI0OpOniE=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    appdirs
    bitarray
    cssselect
    fake-useragent
    lxml
    mutagen
    pillow
    tqdm
    unidecode
    web-cache
    jpegoptim
    optipng
  ];

  # tests require internet connection
  doCheck = false;

  pythonImportsCheck = [ "sacad" ];

  meta = with lib; {
    description = "Smart Automatic Cover Art Downloader";
    homepage = "https://github.com/desbma/sacad";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
