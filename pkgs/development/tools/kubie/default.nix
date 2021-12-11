{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.15.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-XkZbYQaQlRdsXo+4DTbLLYB59ya6DHimhZbdqfWXx1k=";
  };

  cargoSha256 = "sha256-xgqrQbd6tdTu4NkCWGv8UQe8m4wWlm3qJy/Slp7we68=";

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
