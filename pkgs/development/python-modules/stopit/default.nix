{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "stopit";
  version = "1.1.2";

  # tests are missing from the PyPi tarball
  src = fetchFromGitHub {
    owner = "glenfant";
    repo = pname;
    rev = version;
    hash = "sha256-uXJUA70JOGWT2NmS6S7fPrTWAJZ0mZ/hICahIUzjfbw=";
  };

  pythonImportsCheck = [ "stopit" ];

  meta = with lib; {
    description = "Raise asynchronous exceptions in other thread, control the timeout of blocks or callables with a context manager or a decorator";
    homepage = "https://github.com/glenfant/stopit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
