{ lib
, fetchFromGitHub
, stdenvNoCC
, nss
, wrapPython
}:

stdenvNoCC.mkDerivation rec {
  pname = "firefox_decrypt";
  version = "unstable-2021-12-29";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "a3daadc09603a6cf8c4b7e49a59776340bc885e7";
    sha256 = "0g219zqbdnhh9j09d9a0b81vr6j44zzk13ckl5fzkr10gqndiscc";
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
