{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, less
, Security, libiconv, installShellFiles, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0pjdba2c6p7ldgx2yfffxqlpasrcfrlkw63m1ma34zdq0f287w3p";
  };

  cargoSha256 = "0myz06hjv4hwzmyqa9l36i9j9d213a0mnq8rvx6wyff7mr9zk99i";

  nativeBuildInputs = [ pkgconfig installShellFiles makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.fish
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ less ]}"
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = "https://github.com/sharkdp/bat";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq ];
    platforms   = platforms.all;
  };
}
