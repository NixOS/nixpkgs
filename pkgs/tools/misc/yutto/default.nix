{ lib
, buildPythonApplication
, fetchPypi
, pythonOlder
, poetry-core
, aiohttp
, aiofiles
, biliass
, dicttoxml
, colorama
, ffmpeg
, makeWrapper
}:

buildPythonApplication rec {
  pname = "yutto";
  version = "2.0.0b13";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XqfbvlaJoRPpwnaUA52KloOsEOIt3YM0cq36DZN6lR8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    aiofiles
    biliass
    dicttoxml
    colorama
  ];

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  pythonImportsCheck = [ "yutto" ];

  meta = with lib; {
    description = "A Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
