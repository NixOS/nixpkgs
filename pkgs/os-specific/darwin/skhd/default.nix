{ lib
, stdenv
, fetchFromGitHub
, Carbon
, Cocoa
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skhd";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "skhd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fnkWws/g4BdHKDRhqoCpdPFUavOHdk8R7h7H1dAdAYI=";
  };

  buildInputs = [
    Carbon
    Cocoa
  ];

  makeFlags = [
    "BUILD_PATH=$(out)/bin"
  ];

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.skhd.plist} $out/Library/LaunchDaemons/org.nixos.skhd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.skhd.plist --subst-var out
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "skhd-v${finalAttrs.version}";
  };

  meta = {
    description = "Simple hotkey daemon for macOS";
    homepage = "https://github.com/koekeishiya/skhd";
    license = lib.licenses.mit;
    mainProgram = "skhd";
    maintainers = with lib.maintainers; [ cmacrae lnl7 periklis khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
