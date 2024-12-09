{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_hcl";
  version = "0.100.0";

  src = fetchFromGitHub {
    owner = "yethal";
    repo = "nu_plugin_hcl";
    rev = "refs/tags/${version}";
    hash = "sha256-Uj4zzRJ1MtUZBCGc1/wCdh7ZOqLHPQhpdVJBseQR1uE=";
  };

  cargoHash = "sha256-J4i4lDoXcwU5ecyXiHh/4wwQGqp+dkQkwFHsCr2oNFw=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    CoreFoundation
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Nushell plugin for parsing Hashicorp Configuration Language files";
    mainProgram = "nu_plugin_hcl";
    homepage = "https://github.com/yethal/nu_plugin_hcl";
    license = licenses.mit;
    maintainers = with maintainers; [ yethal ];
    platforms = platforms.all;
  };
}
