{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "volta";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "volta-cli";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-24Rc1+zbBli+G3Pe5+fdZTsYShSRKZlhbQLUlw24l7U=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoSha256 = "sha256-/TU1hldQ5ruiD4iPJMppllONDFlOlJFBhtkOmcoQiFY=";

  postInstall = ''
    installShellCompletion --cmd volta \
      --bash <($out/bin/volta completions bash) \
      --fish <($out/bin/volta completions fish) \
      --zsh <($out/bin/volta completions zsh)
  '';

  meta = with lib; {
    description = "JavaScript toolchain manager for reproducible environments";
    homepage = "https://volta.sh/";
    license = lib.licenses.bsd2;
    maintainers = with maintainers; [ kidonng ];
  };
}
