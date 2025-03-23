{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeBinaryWrapper,
}:

bundlerApp {
  pname = "fastlane";
  gemdir = ./.;
  exes = [ "fastlane" ];

  buildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fastlane --set FASTLANE_SKIP_UPDATE_CHECK 1
  '';

  passthru.updateScript = bundlerUpdateScript "fastlane";

  meta = with lib; {
    description = "Tool to automate building and releasing iOS and Android apps";
    longDescription = "fastlane is a tool for iOS and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.";
    homepage = "https://fastlane.tools/";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterromfeldhk
      nicknovitski
      shahrukh330
    ];
    mainProgram = "fastlane";
  };
}
