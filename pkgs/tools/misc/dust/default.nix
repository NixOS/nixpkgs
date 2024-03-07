{ stdenv, lib, fetchFromGitHub, rustPlatform, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-5X7gRMTUrG6ecZnwExBTadOJo/HByohTMDsgxFmp1HM=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-uc7jbA8HqsH1bSJgbnUVT/f7F7kZJ4Jf3yyFvseH7no=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ infinisil ];
    mainProgram = "dust";
  };
}
