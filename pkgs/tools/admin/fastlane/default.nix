{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  inherit ruby;
  pname = "fastlane";
  gemdir = ./.;

  meta = with lib; {
    description     = "A tool to automate building and releasing iOS and Android apps";
    longDescription = "fastlane is a tool for iOS and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.";
    homepage        = https://github.com/fastlane/fastlane;
    license         = licenses.mit;
    maintainers     = with maintainers; [
      peterromfeldhk
    ];
  };
}
