{ rustPlatform, fetchFromSourcehut, lib, wayland, makeWrapper, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "clipmon";
  version = "unstable-2022-08-28";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = pname;
    rev = "2e338fdc2841c3b2de9271d90fcceceda9e45d29";
    hash = "sha256-bEMgJYz3e2xwMO084bmCT1oZImcmO3xH6rIsjvAxnTA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-TI7KVj9SOG+RovkzwMBX3lQ0QFKu1AS5nIHzvHXg/SU=";

  passthru.tests = { inherit (nixosTests) clipmon; };

  postInstall = ''
    wrapProgram $out/bin/clipmon \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~whynothugo/clipmon/";
    description = "Clipboard monitor for Wayland";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
