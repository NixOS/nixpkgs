{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, setuptools-scm
, wheel
, nss
, nix-update-script
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "0931c0484d7429f7d4de3a2f5b62b01b7924b49f";
    hash = "sha256-9HbH8DvHzmlem0XnDbcrIsMQRBuf82cHObqpLzQxNZM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  makeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath [ nss ]) ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "A tool to extract passwords from profiles of Mozilla Firefox and derivates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
