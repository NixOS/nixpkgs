{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = pname;
    rev = version;
    hash = "sha256-uJ8U4knNKAliHjxP0JnV1lSCEsB6OHyYSbb5aWboYV4=";
  };

  cargoHash = "sha256-XVPrtZNLdF9mKSl56kBepkpXRQBJsu9KlZRhb6BeG/E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit ];

  meta = with lib; {
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "lighthouse";
  };
}
