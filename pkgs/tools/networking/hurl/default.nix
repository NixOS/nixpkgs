{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libxml2,
  openssl,
  stdenv,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    hash = "sha256-gSkiNwRR47CZ1YjVa5o8EByCzWBAYPfsMRXydTwFwp0=";
  };

  cargoHash = "sha256-dY00xcMnOCWhdRzC+3mTHSIqeYEPUDBJeYd/GiLM/38=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      libxml2
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      curl
    ];

  # Tests require network access to a test server
  doCheck = false;

  postInstall = ''
    installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
  '';

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [
      eonpatapon
      figsoda
    ];
    license = licenses.asl20;
    mainProgram = "hurl";
  };
}
