{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, pkgconfig, less
, Security, libiconv, installShellFiles, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname   = "bat";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "10cs94ja1dmn0f24gqkcy8rf68b3b43k6qpbb5njbg0hcx3x6cyj";
    fetchSubmodules = true;
  };

  cargoSha256 = "13cphi08bp6lg054acgliir8dx2jajll4m3c4xxy04skmx555zr8";

  # Disable test that's broken on macOS.
  # This should probably be removed on the next release.
  # https://github.com/sharkdp/bat/issues/983
  patches = [ ./macos.patch ];

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
