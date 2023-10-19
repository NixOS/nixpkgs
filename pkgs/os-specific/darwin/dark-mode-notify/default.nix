{ lib
, fetchFromGitHub
, stdenv
, swift
, swiftpm
, darwin
}:

stdenv.mkDerivation (final: {
  pname = "dark-mode-notify";
  version = "unstable-2022-07-18";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "dark-mode-notify";
    rev = "4d7fe211f81c5b67402fad4bed44995344a260d1";
    hash = "sha256-LsAQ5v5jgJw7KsJnQ3Mh6+LNj1EMHICMoD5WzF3hRmU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = with darwin.apple_sdk.frameworks; [
    Foundation
    Cocoa
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Run a script whenever dark mode changes in macOS";
    homepage = "https://github.com/bouk/dark-mode-notify";
    # Doesn't build on x86_64 because of some CoreGraphics issue, even with SDK 11.0
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ YorikSar ];
  };
})
