{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, pkgconfig, less
, Security, libiconv, installShellFiles, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "07yng5bwhin7yqj1hihmxgi8w0n45nks05a8795zwsw92k373ib4";
    fetchSubmodules = true;
  };

  cargoSha256 = "1xqbpij6lr0bqyi0cfwgp3d4hcjhibpdc4dfm9gb39mmbgradrzf";

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang installShellFiles makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

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
    maintainers = with maintainers; [ dywedir lilyball ];
    platforms   = platforms.all;
  };
}
