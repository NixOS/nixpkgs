{
  lib,
  python3Packages,
  fetchPypi,
  jpegoptim,
  optipng,
}:

python3Packages.buildPythonApplication rec {
  pname = "sacad";
  version = "2.7.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZJPcxKc0G8V7x9nyzKXaXpfNpMB3/qRoX0d4lfBZTFY=";
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
    maintainers = with maintainers; [ moni ];
  };
}
