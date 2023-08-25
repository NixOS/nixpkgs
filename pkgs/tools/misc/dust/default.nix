{ stdenv, lib, fetchFromGitHub, rustPlatform, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-PEW13paHNQ1JAz9g3pIdCB1f1KqIz8XC4gGE0z/glOk=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-VJBmVidLkx4nIQULtDoywV4QGmgf53YAAXLJH/LZ/j0=";

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
