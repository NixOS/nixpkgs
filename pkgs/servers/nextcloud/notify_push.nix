{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0quQmi+SFNVlDFUWJYM2WgOCi22KJ/eBLvxBl9+M3g4=";
  };

  cargoHash = "sha256-jZC71OCexTGVq/CguMiDHIbF7QaulIzUaZW2d0x98nw=";

  passthru = {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-a8KcWnHr1bCS255ChOC6piXfVo/nJy/yVHNLCuHXoq4=";
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ajs124 ];
  };
}
