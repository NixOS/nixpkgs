{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "fet-sh";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "6gk";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "1czjsyagwzbf8l023l1saz9ssb1hc245a64nfwc8wl0cn4h9byky";
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
