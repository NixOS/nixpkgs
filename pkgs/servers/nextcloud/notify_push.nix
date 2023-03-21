{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DGWdVsKA8Y1r+/n+vPkRmFt1EAwPYDmFiUcyWZrXeRM=";
  };

  cargoHash = "sha256-H0rkY3hQaOBP8Cai22ppQpZJS1vyFx5uo4k9Paa2yS0=";

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
