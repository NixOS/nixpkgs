{ lib
, stdenv
, fetchFromGitHub
, Cocoa
, CoreFoundation
}:

stdenv.mkDerivation rec {
  pname = "skhd";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fnkWws/g4BdHKDRhqoCpdPFUavOHdk8R7h7H1dAdAYI=";
  };

  buildInputs = [
    Cocoa
    CoreFoundation
  ];

  makeFlags = [ "BUILD_PATH=$(out)/bin" ];

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.skhd.plist} $out/Library/LaunchDaemons/org.nixos.skhd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.skhd.plist --subst-var out
  '';

  meta = with lib; {
    description = "Simple hotkey daemon for macOS";
    homepage = "https://github.com/koekeishiya/skhd";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae lnl7 periklis ];
    license = licenses.mit;
  };
}
