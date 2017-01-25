{ stdenv, fetchFromGitHub, Carbon, Cocoa }:

stdenv.mkDerivation rec {
  name = "khd-${version}";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "khd";
    rev = "v${version}";
    sha256 = "1klia3fywl0c88zbp5wdn6kxhdwdry1jwmkj27vpv8vzvdfzwfmy";
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
