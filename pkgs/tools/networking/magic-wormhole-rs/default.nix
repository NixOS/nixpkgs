{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libxcb
, installShellFiles
, Security
, AppKit
}:
rustPlatform.buildRustPackage rec {
  pname = "magic-wormhole-rs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = version;
    sha256 = "sha256-6dRnOAclHcPayY0e5guhWR5CLaKzp5TlEU5esLvYQg8=";
  };

  cargoHash = "sha256-SPhTvj2DYNzuAtWamDhsgtCTUpQXtnhoRRSE745tB/k=";

  buildInputs = [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ Security AppKit ];

  nativeBuildInputs = [ installShellFiles ];

  # all tests involve networking and are bound fail
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd wormhole-rs \
      --bash <($out/bin/wormhole-rs completion bash) \
      --fish <($out/bin/wormhole-rs completion fish) \
      --zsh <($out/bin/wormhole-rs completion zsh)
  '';

  meta = with lib; {
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    changelog = "https://github.com/magic-wormhole/magic-wormhole.rs/raw/${version}/changelog.md";
    license = licenses.eupl12;
    maintainers = with maintainers; [ zeri piegames ];
    mainProgram = "wormhole-rs";
  };
}
