{ stdenv, fetchFromGitHub, Carbon, Cocoa }:

stdenv.mkDerivation rec {
  name = "khd-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "khd";
    rev = "v${version}";
    sha256 = "02v2bq095h1ylx700kayakg7f9p43vrz6p9ry3g7lq37s6apgm8h";
  };

  buildInputs = [ Carbon Cocoa ];

  prePatch = ''
    substituteInPlace makefile \
      --replace g++ clang++
  '';

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
    description = "A simple modal hototkey daemon for OSX";
    homepage = https://github.com/koekeishiya/khd;
    downloadPage = https://github.com/koekeishiya/khd/releases;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
