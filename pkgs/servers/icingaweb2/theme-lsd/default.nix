{ stdenv, lib, fetchFromGitHub }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-theme-lsd";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = name;
    rev = "v${version}";
    sha256 = "172y08sar4nbyv5pfq5chw8xa3b7fg1dacmsg778zky5zf49qz2w";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Psychadelic theme for IcingaWeb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-lsd";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
