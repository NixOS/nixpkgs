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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = pname;
    rev = version;
    hash = "sha256-3zcMxPOJ4Vvl3HTK13pG3/4duK+2O6i4acv9Uz5zWjA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iVcNwWADF84yQyzIb8WJpJqWGVAaHOVnbdDHFeHXHyI=";

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
