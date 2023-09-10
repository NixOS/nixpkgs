{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hyperfine";
    rev = "v${version}";
    hash = "sha256-IUjOklkEiy/U2HjjMt1X1uSpIkTAYOPiPQ+70xvvxKA=";
  };

  cargoHash = "sha256-VjkcQueBODEADHdWOts2f3Zjar43hi0UXzVhvkK4o8I=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  meta = with lib; {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda thoughtpolice ];
  };
}
