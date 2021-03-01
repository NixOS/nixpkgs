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
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kbziqm00skj65gpjq6m83hmfk9g3xyx88gai1r80pzsx8g239w1";
  };

  cargoSha256 = "1pdja5jhk036hpgv77xc3fcvra1sw0z5jc1ry53i0r7362lnwapz";

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

  passthru.tests = { inherit (nixosTests) bat; };

  meta = with lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq ];
  };
}
