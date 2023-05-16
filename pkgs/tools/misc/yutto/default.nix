{ lib
, python3
<<<<<<< HEAD
, fetchPypi
, ffmpeg
=======
, ffmpeg
, makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix-update-script
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "yutto";
<<<<<<< HEAD
  version = "2.0.0b28";
=======
  version = "2.0.0b24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-jN9KDQjEaTf7BUDtGd07W3TtijRKzD+StMReLmX4QI0=";
=======
    hash = "sha256-ZnRDGgJu78KoSHvznYhBNEDJihUm9rUdlb5tXmcpuTc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    aiofiles
    biliass
<<<<<<< HEAD
    dict2xml
=======
    dicttoxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
