{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valpackett";
    repo = pname;
    rev = version;
    hash = "sha256-lCXDDLovUb5aSOPTyVJL25v1JT1BGrrUlUR0Mu0XX4Q=";
  };

  cargoHash = "sha256-KcQZnGFtev4ckhtQ7CNB773fAsExZ9EQl9e4Jf4beGo=";

  meta = with lib; {
    homepage = "https://codeberg.org/valpackett/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    mainProgram = "evscript";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
