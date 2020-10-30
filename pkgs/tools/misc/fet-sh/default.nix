{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "fet-sh";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "6gk";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "02izkwfph4i62adwns4q4w1pfcmdsczm8ghagx5yb9315ww3adzn";
  };

  dontBuild = true;

  installPhase = ''
    install -m755 -D ./fet.sh $out/bin/fet.sh
  '';

  meta = with lib; {
    description = "A fetch written in posix shell without any external commands (linux only)";
    homepage = "https://github.com/6gk/fet.sh";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elkowar ];
  };

}
