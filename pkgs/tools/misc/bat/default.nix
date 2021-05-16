{ lib, stdenv
, nixosTests
, rustPlatform
, fetchFromGitHub
, pkg-config
, less
, Security
, libiconv
, installShellFiles
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kyl+clL/4uxVaDH/9zPDGQTir4/JVgtHo9kNQ31gXTo=";
  };

  cargoSha256 = "sha256-j9HbOXiwN4CWv9wMBrNxY3jehh+KRkXlwmDqChNy1Dk=";

  nativeBuildInputs = [ pkg-config installShellFiles makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  checkFlags = [ "--skip=pager_more" "--skip=pager_most" ];

  passthru.tests = { inherit (nixosTests) bat; };

  meta = with lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq ];
  };
}
