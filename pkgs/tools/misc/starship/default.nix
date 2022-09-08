{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, cmake
, fetchpatch
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6YpC6JDBYwP+RHQUYXmgOWUWa7DgvjowhGCpr2bNl4Q=";
  };

  nativeBuildInputs = [ installShellFiles cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa ];

  buildNoDefaultFeatures = true;
  # the "notify" feature is currently broken on darwin
  buildFeatures = if stdenv.isDarwin then [ "battery" ] else [ "default" ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)
  '';

  cargoSha256 = "sha256-skNvlifjRHTrJPMjpRv2E+M9/XA+3m6dHbb+gczaYoo=";

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
