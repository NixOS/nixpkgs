{ stdenv, pkgs, fetchurl }:

stdenv.mkDerivation rec {
  name = "i3lock-pixeled-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/Ma27/i3lock-pixeled/archive/${version}.tar.gz";
    sha256 = "046qbx4qvcc66h53h4mm9pyjj9gjc6dzy38a0f0jc5a84xbivh7k";
  };

  propagatedBuildInputs = with pkgs; [
    i3lock
    imagemagick
    scrot
    playerctl
  ];

  buildPhases = [ "unpackPhase" "patchPhase" "installPhase" ];
  makeFlags = [
    "PREFIX=$(out)/bin"
  ];

  patchPhase = ''
    substituteInPlace i3lock-pixeled \
       --replace i3lock    "${pkgs.i3lock}/bin/i3lock" \
       --replace convert   "${pkgs.imagemagick}/bin/convert" \
       --replace scrot     "${pkgs.scrot}/bin/scrot" \
       --replace playerctl "${pkgs.playerctl}/bin/playerctl"
  '';

  meta = with stdenv.lib; {
    description = "Simple i3lock helper which pixels a screenshot by scaling it down and up to get a pixeled version of the screen when the lock is active.";
    homepage = https://github.com/Ma27/i3lock-pixeled;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
