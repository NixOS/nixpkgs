{
  lib,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bitbake";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "meta-rust";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+ovC4nZwHzf9hjfv2LcnTztM2m++tpC3mUSS/I0l6Ck=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoSha256 = "sha256-LYdQ0FLfCopY8kPTCmiW0Qyx6sHA4nlb+hK9hXezGLg=";

  meta = with lib; {
    description = "Cargo extension that can generate BitBake recipes utilizing the classes from meta-rust";
    mainProgram = "cargo-bitbake";
    homepage = "https://github.com/meta-rust/cargo-bitbake";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ rvarago ];
    platforms = [ "x86_64-linux" ];
  };
}
