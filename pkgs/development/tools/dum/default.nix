{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dum";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "egoist";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rnm59zhpaa8nbbh6rh53svnlb484q1k6s4wc4w9516b18xhmkca";
  };

  cargoSha256 = "sha256-aMx4xfWYiiz5TY/CVCogZ3WNR6md77jb8RKhhVwqeto=";

  meta = with lib; {
    description = "An npm scripts runner written in Rust";
    mainProgram = "dum";
    homepage = "https://github.com/egoist/dum";
    changelog = "https://github.com/egoist/dum/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
