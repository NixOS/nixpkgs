{ stdenv
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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "161pfix42j767ziyp4mslffdd20v9i0ncplvjw2pmpccwdm106kg";
  };

  cargoSha256 = "19vhhxfyx3nrngcs6dvwldnk9h4lvs7xjkb31aj1y0pyawz882h9";

  nativeBuildInputs = [ pkg-config installShellFiles makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ less ]}"
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq ];
  };
}
