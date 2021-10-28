{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf
, installShellFiles
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "sha256-NGSeGrYEWYE1gmYZs4UmZCIKJKckROWZtl+PykGWDEM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/fzf.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "sha256-gtXIMYklcQg75VUuPzftI9OJ+S8iutpnJAT37VsB+KY=";

  postInstall = ''
    installManPage man/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
  };
}
