{ lib, stdenv, i3lock, imagemagick, scrot, playerctl, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "i3lock-pixeled";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "Ma27";
    repo = "i3lock-pixeled";
    rev = version;
    sha256 = "1l9yjf9say0mcqnnjkyj4z3f6y83bnx4jsycd1h10p3m8afbh8my";
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

  meta = with lib; {
    description = "Simple i3lock helper which pixels a screenshot by scaling it down and up to get a pixeled version of the screen when the lock is active";
    mainProgram = "i3lock-pixeled";
    homepage = "https://gitlab.com/Ma27/i3lock-pixeled";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
