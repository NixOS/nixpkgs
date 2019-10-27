{ stdenv, lib, fetchFromGitHub }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-theme-particles";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = name;
    rev = "v${version}";
    sha256 = "0m6bbz191686k4djqbk8v0zcdm4cyi159jb3zwz7q295xbpi2vfy";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "This theme adds a nice particle effect to the login screen of Icingaweb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-particles";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
