{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  name = "tt-rss-plugin-tumblr-gdpr-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "GregThib";
    repo = "ttrss-tumblr-gdpr";
    rev = "v${version}";
    sha256 = "09cbghi5b6ww4i5677i39qc9rhpq70xmygp0d7x30239r3i23rpq";
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
