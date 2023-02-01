{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.19.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-foY1fcIn+jywABwEVBWctx4zwLg7k2zxkpL8UAhx6kA=";
  };

  cargoHash = "sha256-WHaORWwR7PeKacaCtXjTYMTCyZ4ZFWo1smVx5ig+Z9U=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
