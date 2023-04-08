{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
, xvfb-run
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P8PTEbTWI+vwWiPvjr4yTwO/JfPzfpUPO0ATi1ILhfk=";
  };

  cargoHash = if stdenv.isLinux then "sha256-T3Y6WiU6UdLmZiXYekL5cIonqFisU94PpiVlB1sNr9U=" else "sha256-a81gKajbifhDqlKlpnA4FzVX+NktqOCRqlajuuYopCg=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  nativeCheckInputs = lib.optionals xvfb-run.meta.available [
    xvfb-run
  ];

  checkPhase = lib.optionalString xvfb-run.meta.available ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
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
