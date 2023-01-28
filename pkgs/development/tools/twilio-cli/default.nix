{ lib, stdenvNoCC, nodejs, fetchzip, testers }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "twilio-cli";
  version = "5.3.3";

  src = fetchzip {
    url = "https://twilio-cli-prod.s3.amazonaws.com/twilio-v${finalAttrs.version}/twilio-v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-4ZgPytpv2yxKXADGR4I5+U0YjsvGEvcaF0cGrCJ21aI=";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/twilio-cli
    cp -R . $out/libexec/twilio-cli
    ln -s $out/libexec/twilio-cli/bin/run $out/bin/twilio

    runHook postInstall
  '';

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "twilio version";
  };

  meta = with lib; {
    description = "Unleash the power of Twilio from your command prompt";
    homepage = "https://github.com/twilio/twilio-cli";
    changelog = "https://github.com/twilio/twilio-cli/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    platforms = nodejs.meta.platforms;
    mainProgram = "twilio";
  };
})
