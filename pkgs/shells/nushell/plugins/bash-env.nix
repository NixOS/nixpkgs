{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
  makeWrapper,
  resholve,
  nushell,
  bash,
  jq,
  coreutils,
  IOKit,
  Foundation,
}:
rustPlatform.buildRustPackage {
  pname = "nu-plugin-bash-env";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tesujimath";
    repo = "nu_plugin_bash_env";
    rev = "0.13.0";
    hash = "sha256-fWFBGeNqrJj+fT8EusS8VhxoCmncqhQUplPEHOJlqRA=";
  };

  cargoHash = "sha256-z5pl1QjNLldXuj2ZWPlMEr/IeR9Fx73ZYDisIhEFxnY=";
  passthru.updateScript = unstableGitUpdater { };

  buildInputs = lib.optionals stdenv.isDarwin [
    IOKit
    Foundation
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm755 $src/scripts/bash_env.sh $out/libexec/bash_env
  '';

  postFixup = ''
    ${resholve.phraseSolution "bash_env" {
      scripts = [ "libexec/bash_env" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        jq
        coreutils
      ];
      keep = {
        "source" = [ "$_path" ];
      };
    }}
    wrapProgram $out/bin/nu_plugin_bash_env \
      --set NU_PLUGIN_BASH_ENV_SCRIPT $out/libexec/bash_env
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    ${nushell}/bin/nu -c "
      plugin add --plugin-config /tmp/plugins.msgpackz $out/bin/nu_plugin_bash_env
    "
    ${nushell}/bin/nu -c "
      plugin use --plugin-config /tmp/plugins.msgpackz bash_env
      use $src/tests.nu run_bash_env_tests
      run_bash_env_tests
    "
  '';

  meta = {
    description = "A Bash environment plugin for Nushell";
    homepage = "https://github.com/tesujimath/nu_plugin_bash_env";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.misterio77 ];
  };
}
