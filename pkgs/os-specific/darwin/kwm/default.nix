{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "kwm-${version}";
  version = "4.0.4";

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/koekeishiya/kwm/releases/download/v${version}/Kwm-${version}.zip";
    sha256 = "07rf4ichq511w8qmvd6s602s7xcyjhjp73d5c615sj82cxvgirwc";
  };

  # TODO: Build this properly once we have swiftc.
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp kwmc $out/bin/kwmc
    cp kwm overlaylib.dylib $out

    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.kwm.plist} $out/Library/LaunchDaemons/org.nixos.kwm.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.kwm.plist --subst-var out
  '';

  meta = with stdenv.lib; {
    description = "Tiling window manager with focus follows mouse for OSX";
    homepage = https://github.com/koekeishiya/kwm;
    downloadPage = https://github.com/koekeishiya/kwm/releases;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
