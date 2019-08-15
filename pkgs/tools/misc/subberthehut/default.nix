{ stdenv, fetchFromGitHub, pkgconfig, xmlrpc_c, glib, zlib }:
stdenv.mkDerivation rec {
  pname = "subberthehut";
  version = "20";

  src = fetchFromGitHub {
    owner  = "mus65";
    repo   = "subberthehut";
    rev    = version;
    sha256 = "19prdqbk19h0wak318g2jn1mnfm7l7f83a633bh0rhskysmqrsj1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ xmlrpc_c glib zlib ];

  installPhase = ''
    install -Dm755 subberthehut $out/bin/subberthehut
    install -Dm644 bash_completion $out/share/bash-completion/completions/subberthehut
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mus65/subberthehut;
    description = "An OpenSubtitles.org downloader";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
