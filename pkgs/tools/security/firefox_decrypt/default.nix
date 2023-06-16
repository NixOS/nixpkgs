{ lib
, fetchFromGitHub
, stdenvNoCC
, nss
, wrapPython
, nix-update-script
}:

stdenvNoCC.mkDerivation rec {
  pname = "firefox_decrypt";
  version = "unstable-2023-05-14";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "ac857efde75d86dd6bd5dfca25d4a0f73b75009f";
    sha256 = "sha256-34QS98nmrL98nzoZgeFSng8TJJc9BU1+Tzh2b+dsuCc=";
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
