{ lib
, python3
, fetchPypi
, ffmpeg
, nix-update-script
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "yutto";
  version = "2.0.0b30";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QQExmnpn+CgNRyV/cQbYpgGCM2r8DzOMdNzgN+DvSos=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    aiofiles
    biliass
    dict2xml
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
