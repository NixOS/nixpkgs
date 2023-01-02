{ lib
, fetchFromGitHub
, stdenvNoCC
, nss
, wrapPython
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "firefox_decrypt";
  version = "unstable-2022-12-21";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
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

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "A tool to extract passwords from profiles of Mozilla Firefox and derivates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
