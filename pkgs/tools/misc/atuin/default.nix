{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, AppKit
, Security
, SystemConfiguration
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-eGukHoh1S2CtehapSRUM3+cnVvTpslwvDCSXlrnC4+4=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-KlfNOZ5xDID+x0GohbLv+SJlPQRK6C5YzbbFnKvm2ng="
    else "sha256-8OarzrMc7EiHEDDbs2XiggivebQ68yufnmhXsf6MBwM=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv AppKit Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) atuin;
  };

  checkFlags = [
    # tries to make a network access
    "--skip=registration"
    # No such file or directory (os error 2)
    "--skip=sync"
  ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 sciencentistguy _0x4A6F ];
  };
}
