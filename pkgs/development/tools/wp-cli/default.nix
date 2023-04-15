{ lib, fetchFromGitHub, php, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  pname = "wp-cli";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "wp-cli";
    repo = "wp-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lLuOozVbaaKbfUemhcQBD1t4dqixX+Vw7f+XXc9NsnU=";
  };

  # TODO: Open a PR against https://github.com/wp-cli/wp-cli
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-ROTimNrEoVzfVbGm1yYqA32XDzGVn5beIoFNetAAiyo=";

  nativeBuildInputs = [
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

  meta = {
    description = "A command line interface for WordPress";
    homepage = "https://wp-cli.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.peterhoeg ];
    mainProgram = "wp";
  };
})
