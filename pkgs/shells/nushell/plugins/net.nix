{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu-plugin-net";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "refs/tags/${version}";
    hash = "sha256-GOF2CSlsjI8PAmIxj/+mR01X5XMviEM8gj7ZYTbeX7I=";
  };

  cargoHash = "sha256-2FjKGirjTb6ZjDmhK9ciQzVtWCF8CcYeA+YXcr1oMP4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu_plugin_net";
  };
}
