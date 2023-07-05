{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, hidapi
, python3
, bashInteractive
}:

rustPlatform.buildRustPackage rec {
  pname = "nitrocli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "d-e-s-o";
    repo = "nitrocli";
    rev = "7991b9cb4a8fee2ea5ffd11f6fed2bd7f5cded21";
    sha256 = "0xy169qf5vckvzx48lmkcpd83pw5crnvfl8a7p5wp2cbkrl60pnc";
  };

  cargoHash = "sha256-sEM8aznsz5tw9W/N2ZtCpPY8SqOEUBS+WG7V26Qms0g=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    hidapi
  ];

  # Some patches are required for three of the tests to pass. Alternatively the
  # build will succeed if these three tests are skipped.
  prePatch = ''
     pythonInterpreterEscaped=$(echo ${python3}/bin/python3 | sed 's/\//\\\//g')
     sed -i "s/\/usr\/bin\/env python/$pythonInterpreterEscaped/" src/tests/run.rs

     bashInterpreterEscaped=$(echo ${bashInteractive}/bin/bash | sed 's/\//\\\//g')
     sed -i "s/process::Command::new(\"bash\")/process::Command::new(\"$bashInterpreterEscaped\")/" var/shell-complete.rs
  '';

  # Instead of applying the patches above, these tests can skipped.
  #checkFlags = [
  #  # these tests require a python shebang to substituted
  #  "--skip=tests::run::extension"
  #  "--skip=tests::run::extension_failure"

  #  # this test requires a command to run bash to be substituted
  #  "--tests::complete_all_the_things"
  #];

  postInstall = ''
    installManPage doc/nitrocli.1

    installShellCompletion --cmd nitrocli \
     --bash <($out/bin/shell-complete bash) \
     --fish <($out/bin/shell-complete fish) \
     --zsh <($out/bin/shell-complete zsh)

    rm $out/bin/shell-complete
  '';

  meta = {
    description = "A command line tool for interacting with Nitrokey devices";
    homepage = "https://github.com/d-e-s-o/nitrocli";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.tarnacious ];
    # There are reports of sucess and problems on darwin. It sounds like this
    # could be solved with Nix but it's currently only supported on Linux.
    # https://github.com/d-e-s-o/nitrocli/issues/1
    platforms = lib.platforms.linux;
  };
}
