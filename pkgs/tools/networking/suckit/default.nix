{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "suckit";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "skallwar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M4/vD1sVny7hAf4h56Z2xy7yuCqH/H3qHYod6haZOs0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-20Fz98mAkmhk7g0359S7Gjg6i89cXtKuS/9bVzOagBs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  # requires internet access
  checkFlags = [
    "--skip=test_download_url"
    "--skip=test_external_download"
  ];

  meta = with lib; {
    description = "Recursively visit and download a website's content to your disk";
    homepage = "https://github.com/skallwar/suckit";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "suckit";
  };
}
