{ stdenv, fetchFromGitHub, Carbon, Cocoa }:

stdenv.mkDerivation rec {
  name = "khd-${version}";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "khd";
    rev = "v${version}";
    sha256 = "1ijfrlnwdf8hk259j3jfxj6zizvqzj57458rflza626z5dnhmbpr";
  };

  buildInputs = [ Carbon Cocoa ];

  buildPhase = ''
    make install
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/khd $out/bin/khd

    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.khd.plist} $out/Library/LaunchDaemons/org.nixos.khd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.khd.plist --subst-var out
  '';

  meta = with stdenv.lib; {
    description = "A simple modal hotkey daemon for OSX";
    homepage = https://github.com/koekeishiya/khd;
    downloadPage = https://github.com/koekeishiya/khd/releases;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
