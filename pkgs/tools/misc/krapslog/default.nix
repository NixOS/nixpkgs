{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-BaR72djkvaMmdBqbykezLkY81Y7iajhNPcFGYq/qv7Y=";
  };

  cargoSha256 = "sha256-rcLsqMegCos+v0OkdRvH9xoopE7R/njEUVteMY/6mj8=";

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
