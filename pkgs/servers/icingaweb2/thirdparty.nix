{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-thirdparty";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-thirdparty";
    rev = "v${version}";
    sha256 = "sha256-TQq80raZO4SjrQTT6IKHXxbiprSV1vtR/FzNmh4bIt8=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Third party dependencies for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-thirdparty";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
