{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  inherit ruby;
  pname = "fastlane";
  gemdir = ./.;

  meta = with lib; {
    description = "fastlane is a tool for iOS and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.";
    homepage    = https://github.com/fastlane/fastlane;
    license     = licenses.mit;
    platforms   = with platforms; linux ++ darwin;
  };
}
