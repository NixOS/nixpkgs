{ stdenv, lib, fetchFromGitHub }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-theme-april";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = name;
    rev = "v${version}";
    sha256 = "0i1js2k47llzgmc77q9frvcmr02mqlhg0qhswx1486fvm6myxg0g";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Icingaweb2 theme for april fools";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-april";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
