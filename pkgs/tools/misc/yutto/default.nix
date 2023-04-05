{ lib
, python3
, ffmpeg
, makeWrapper
, nix-update-script
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "yutto";
  version = "2.0.0b21";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x1ncWaNZ0MQ4hYCGnfwR4pU0Hp1IgiruxU8HMFL9dnk=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Bilibili downloader";
    homepage = "https://github.com/yutto-dev/yutto";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
