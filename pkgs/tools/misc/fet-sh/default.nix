{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "fet-sh";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "6gk";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "15336cayv3rb79y7f0v0qvn6nhr5aqr8479ayp0r0sihn5mkfg35";
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
