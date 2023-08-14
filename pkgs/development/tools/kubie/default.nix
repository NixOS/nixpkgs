{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.21.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-fkIKb2fcml9E2sSJwhYPrqiThFgpNYh1CampQu8RT4k=";
  };

  cargoHash = "sha256-zZwSLMuuaQ8Ht6Ux/wrqB/VEHCvBqTQGvg+RSr8+AiQ=";

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
