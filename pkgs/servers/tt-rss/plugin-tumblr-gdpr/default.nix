{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  name = "tt-rss-plugin-tumblr-gdpr-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "GregThib";
    repo = "ttrss-tumblr-gdpr";
    rev = "v${version}";
    sha256 = "1qqnzysg1d0b169kr9fbgi50yjnvw7lrvgrl2zjx6px6z61jhv4j";
  };

  installPhase = ''
    mkdir -p $out/tumblr_gdpr

    cp init.php $out/tumblr_gdpr
  '';

  meta = with stdenv.lib; {
    description = "Plugin for TT-RSS to workaround GDPR in Europe";
    longDescription = ''
      Plugin for TT-RSS to workaround GDPR in Europe.

      The name of the plugin in TT-RSS is 'tumblr_gdpr'.
    '';
    license = licenses.gpl3;
    homepage = https://github.com/GregThib/ttrss-tumblr-gdpr;
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
