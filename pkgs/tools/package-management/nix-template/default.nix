{ lib, stdenv, rustPlatform, fetchFromGitHub
, installShellFiles
, makeWrapper
, nix
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-template";
  version = "0.1.4";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "jonringer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kNFhSfHUYBUOCXoD6m7thMho4tOIpRHfHGcsW8FTgkc=";
  };

  cargoSha256 = "sha256-7PthFLCEt+E/Gx5//aulHYYBKZqapNEWKtKfRlDr3Pw=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # needed for nix-prefetch-url
  postInstall = ''
    wrapProgram $out/bin/nix-template \
      --prefix PATH : ${lib.makeBinPath [ nix ]}

    installShellCompletion --bash --cmd nix-template <($out/bin/nix-template completions bash)
    installShellCompletion --zsh --cmd nix-template <($out/bin/nix-template completions zsh)
    installShellCompletion --fish --cmd nix-template <($out/bin/nix-template completions fish)
  '';

  meta = with lib; {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
