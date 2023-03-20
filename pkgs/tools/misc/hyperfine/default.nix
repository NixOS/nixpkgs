{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-cbox7TAgeb0ZPt0i3SphWClAz/mUUgRlFKCOS/E0MT4=";
  };

  cargoSha256 = "sha256-Bc3twE42iB7NNkI5cPcniEb+JcR1wjc9nx80p6HCDVc=";

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
