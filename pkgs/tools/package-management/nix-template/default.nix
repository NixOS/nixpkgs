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
  version = "0.3.0";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "jonringer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5redgssfwbNEgpjmakIcU8cL4Xg1kPvyK88v+xMqAtw=";
  };

  cargoSha256 = "sha256-d4gxOIpgtVBpqy4QGW4/UB/FP94CS+yzS8GCjRVaXOM=";

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

    installShellCompletion --cmd nix-template \
      --bash <($out/bin/nix-template completions bash) \
      --fish <($out/bin/nix-template completions fish) \
      --zsh <($out/bin/nix-template completions zsh)
  '';

  meta = with lib; {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
