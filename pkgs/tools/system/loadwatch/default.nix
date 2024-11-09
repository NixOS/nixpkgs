{ lib, stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "loadwatch";
  version = "1.1-1-g6d2544c";

  src = fetchgit {
    url = "git://woffs.de/git/fd/loadwatch.git";
    sha256 = "1bhw5ywvhyb6snidsnllfpdi1migy73wg2gchhsfbcpm8aaz9c9b";
    rev = "6d2544c0caaa8a64bbafc3f851e06b8056c30e6e";
  };

  installPhase = ''
    mkdir -p $out/bin
    install loadwatch lw-ctl $out/bin
  '';

  meta = with lib; {
    description = "Run a program using only idle cycles";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ woffs ];
    platforms = platforms.all;
  };
}
