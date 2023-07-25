{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BX1WpvJMcfpepsRX0U6FJBL5/+mpUyTZxm65BbbZLJA=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-EnIR+BXw8oYlv3dpYy4gAkN/zckRI8KEAbbR9wPmMq4="
    else "sha256-hHcahzrIuXIgOv+sx0HbC9f5guTcTr6L4eeLoiQsAzA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) atuin;
  };

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 sciencentistguy _0x4A6F ];
  };
}
