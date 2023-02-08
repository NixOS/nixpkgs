{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, cmake
, fetchpatch
, git
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HS+vtF+h5M6lbk7TROAXwrHpj92SeC+j0TjmP6ycH2Q=";
  };

  nativeBuildInputs = [ installShellFiles cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security Foundation Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)
  '';

  cargoHash = "sha256-hs0ImaozKH6QcUfts+oseUqecg7bGX5cx50ixnNamW8=";

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
  };
}
