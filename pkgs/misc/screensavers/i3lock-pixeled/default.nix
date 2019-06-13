{ stdenv, i3lock, imagemagick, scrot, playerctl, fetchFromGitLab }:

stdenv.mkDerivation rec {
  name = "i3lock-pixeled-${version}";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "Ma27";
    repo = "i3lock-pixeled";
    rev = version;
    sha256 = "0pysx9sv4i3nnjvpqkrxkxaqja2a2dw5f2r1bzjcgg3c3c5qv74b";
  };

  propagatedBuildInputs = [
    i3lock
    imagemagick
    scrot
    playerctl
  ];

  makeFlags = [
    "PREFIX=$(out)/bin"
  ];

  patchPhase = ''
    substituteInPlace i3lock-pixeled \
       --replace i3lock    "${i3lock}/bin/i3lock" \
       --replace convert   "${imagemagick}/bin/convert" \
       --replace scrot     "${scrot}/bin/scrot" \
       --replace playerctl "${playerctl}/bin/playerctl"
  '';

  meta = with stdenv.lib; {
    description = "Simple i3lock helper which pixels a screenshot by scaling it down and up to get a pixeled version of the screen when the lock is active.";
    homepage = https://gitlab.com/Ma27/i3lock-pixeled;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
