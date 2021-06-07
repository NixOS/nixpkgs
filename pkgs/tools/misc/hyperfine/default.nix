{ lib, stdenv, fetchCrate, rustPlatform, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0dla2jzwcxkdx3n4fqkkh6wirqs2f31lvqsw2pjf1jbnnif54mzh";
  };

  cargoSha256 = "13dd5x0mr1pqcba48w9v5jjpddapd7gk34d4bysbjqsriwpbrdgp";

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
    homepage    = "https://github.com/sharkdp/hyperfine";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
