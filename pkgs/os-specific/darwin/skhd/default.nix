{ stdenv, fetchFromGitHub, Carbon }:

stdenv.mkDerivation rec {
  name = "skhd-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "skhd";
    rev = "v${version}";
    sha256 = "1wh7v90ydh27gbaiwn2r6ncx6yiic4mph3w9vi1282nz2q02zxss";
  };

  buildInputs = [ Carbon ];

  makeFlags = [ "BUILD_PATH=$(out)/bin" ];

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.skhd.plist} $out/Library/LaunchDaemons/org.nixos.skhd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.skhd.plist --subst-var out
  '';

  meta = with stdenv.lib; {
    description = "Simple hotkey daemon for macOS";
    homepage = https://github.com/koekeishiya/skhd;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
