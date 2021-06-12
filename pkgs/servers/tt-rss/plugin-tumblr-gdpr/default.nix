{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-tumblr-gdpr";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "GregThib";
    repo = "ttrss-tumblr-gdpr";
    rev = "v${version}";
    sha256 = "sha256-oCdpgfOvXNui2KaS48WeyVy8Of6IlPOxQR6gmPiyH0s=";
  };

  installPhase = ''
    mkdir -p $out/tumblr_gdpr

    cp init.php $out/tumblr_gdpr
  '';

  meta = with lib; {
    description = "Plugin for TT-RSS to workaround GDPR in Europe";
    longDescription = ''
      Plugin for TT-RSS to workaround GDPR in Europe.

      The name of the plugin in TT-RSS is 'tumblr_gdpr'.
    '';
    license = licenses.gpl3;
    homepage = "https://github.com/GregThib/ttrss-tumblr-gdpr";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
