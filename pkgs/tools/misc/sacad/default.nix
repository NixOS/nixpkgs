{ lib, python3Packages, jpegoptim, optipng }:

python3Packages.buildPythonApplication rec {
  pname = "sacad";
  version = "2.4.0";

  src = python3Packages.fetchPypi {
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
