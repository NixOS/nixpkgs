{ stdenv, fetchFromGitHub, Carbon, CoreAudio }:

stdenv.mkDerivation rec {
  name = "skhd-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "skhd";
    rev = "v${version}";
    sha256 = "0bmsr4g2sm1hps9rqpcfp3b9yfp3bidjyfbhx8f8a7mlpk59ib4c";
  };

  buildInputs = [ Carbon CoreAudio ];

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
    maintainers = with maintainers; [ lnl7 periklis rvolosatovs ];
    license = licenses.mit;
  };
}
