{ lib
, python3
, fetchPypi
, ffmpeg
, nix-update-script
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "yutto";
  version = "2.0.0b35";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r4Lc5PMkhwLMC6nKArvpf9M4N+eoV6OmZK2uhY6xZxA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
    aiofiles
    biliass
    dict2xml
    colorama
    typing-extensions
  ] ++ (with httpx.optional-dependencies; http2 ++ socks);

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
    mainProgram = "yutto";
  };
}
