{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.17.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YjGfnYK22RIVa8D8CWnAxHGDqXENGAPIeQQ606Q3JW8=";
  };

  cargoHash = "sha256-Fx/XNmml/5opekmH1qs/f3sD45KWfNZjdOxTuNJfZiw=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  meta = with lib; {
    description = "Command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    changelog = "https://github.com/EFForg/apkeep/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "apkeep";
  };
}
