{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_net";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "refs/tags/${version}";
    hash = "sha256-HiNydU40FprxVmRRZtnXom2kFYI04mbeuGTq8+BMh7o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tq0XqY2B7tC2ep8vH6T3nkAqxqhniqzYnhbkfB3SbHU=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu_plugin_net";
  };
}
