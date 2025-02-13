{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  CoreServices,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8kYaANVWmBOncTdhtjjbaYnEFQeuWjemdz/kTjwj2fw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m6bYkewBE0ZloDVUhUslS+dgPyoK+eay7rrP3+c00mo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreServices
    Security
  ];

  meta = with lib; {
    description = "Infinitely transfer between every device over pure HTTP with pipes or browsers";
    homepage = "https://github.com/nwtgck/piping-server-rust";
    changelog = "https://github.com/nwtgck/piping-server-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piping-server";
  };
}
