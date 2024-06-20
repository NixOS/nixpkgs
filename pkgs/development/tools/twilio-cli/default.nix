{ lib, stdenvNoCC, nodejs-slim, fetchzip, testers }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "twilio-cli";
  version = "5.21.0";

  src = fetchzip {
    url = "https://twilio-cli-prod.s3.amazonaws.com/twilio-v${finalAttrs.version}/twilio-v${finalAttrs.version}.tar.gz";
    hash = "sha256-rtI89baKJS4itwTcHY9IjKeskQO6mz/c746wdVy4cG4=";
  };

  buildInputs = [ nodejs-slim ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/twilio-cli
    cp -R . $out/libexec/twilio-cli
    ln -s $out/libexec/twilio-cli/bin/run $out/bin/twilio

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Unleash the power of Twilio from your command prompt";
    homepage = "https://github.com/twilio/twilio-cli";
    changelog = "https://github.com/twilio/twilio-cli/blob/${finalAttrs.version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = nodejs-slim.meta.platforms;
    mainProgram = "twilio";
  };
})
