{ lib, fetchFromGitHub, fetchpatch, php, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  pname = "wp-cli";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "wp-cli";
    repo = "wp-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dJSrXhTgtb7wHftXEui3HyiWC9NEgVx7n3f42V9xQl8=";
  };

  # TODO: Open a PR against https://github.com/wp-cli/wp-cli
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-UzTOR0um5/9tjlCL35Z1BzPnf2vLwTzfTMnCQhm2iRI=";

  nativeBuildInputs = finalAttrs.buildInputs ++ [
    makeBinaryWrapper
  ];

  php = php.buildEnv {
    extraConfig = ''
      phar.readonly=0
    '';
  };

  postInstall = ''
    wrapProgram $out/bin/wp \
      --prefix PATH ":" ${lib.makeBinPath [ php ]}
  '';

  meta = with lib; {
    description = "A command line interface for WordPress";
    homepage = "https://wp-cli.org";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "wp";
  };
})
