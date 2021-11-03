{ lib, rustPlatform, fetchFromGitHub, help2man, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-I9CgkYxcK+Ih9UlcYBa8QAZZsPvzPUK5ZUYKPxzgs38=";
  };

  cargoSha256 = "sha256-jEprWtIl5LihD9fOMYHGGlk0+h4woUlwUWNfSkd2t10=";

  nativeBuildInputs = [ help2man installShellFiles ];

  postInstall = ''
    help2man $out/bin/ouch > ouch.1
    installManPage ouch.1

    completions=($releaseDir/build/ouch-*/out/completions)
    installShellCompletion $completions/ouch.{bash,fish} --zsh $completions/_ouch
  '';

  GEN_COMPLETIONS = 1;

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda psibi ];
  };
}
