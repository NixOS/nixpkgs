{ lib
, fetchFromGitHub
<<<<<<< HEAD
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
=======
, stdenvNoCC
, nss
, wrapPython
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "firefox_decrypt";
  version = "unstable-2022-12-21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
<<<<<<< HEAD
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
=======
    rev = "84bb368cc2f8d2055a8374ab1a40c403e0486859";
    sha256 = "sha256-dyQTf6fgsQEmp++DeXl85nvyezm0Lq9onyfIdhQoGgI=";
  };

  nativeBuildInputs = [ wrapPython ];

  buildInputs = [ nss ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 firefox_decrypt.py "$out/bin/firefox_decrypt"

    runHook postInstall
  '';

  makeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath [ nss ]) ];

  postFixup = ''
    wrapPythonPrograms
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "A tool to extract passwords from profiles of Mozilla Firefox and derivates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
