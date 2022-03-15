{ lib
, fetchFromGitHub
, stdenvNoCC
, nss
, wrapPython
}:

stdenvNoCC.mkDerivation rec {
  pname = "firefox_decrypt";
  version = "unstable-2022-09-28";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "53325de4fe7f502397799d2eb25844dd1f935e3b";
    sha256 = "sha256-bRH7PVJXMg6Xv9niOCSZRHATkB7Wbb8iLak0VtjJV7I=";
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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "A tool to extract passwords from profiles of Mozilla Firefox and derivates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
