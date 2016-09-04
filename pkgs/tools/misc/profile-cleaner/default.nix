{ stdenv, fetchFromGitHub, makeWrapper, parallel, sqlite }:

stdenv.mkDerivation rec {
  version = "2.35";
  name = "profile-cleaner-${version}";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-cleaner";
    rev = "v${version}";
    sha256 = "0gashrzhpgcy98zsyc6b3awfp15j1x0nq82h60kvfjbs6xxzvszh";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    wrapProgram $out/bin/profile-cleaner \
      --prefix PATH : "${stdenv.lib.makeBinPath [ parallel sqlite ]}"
  '';

  meta = {
    description = "Reduces browser profile sizes by cleaning their sqlite databases";
    longDescription = ''
      Use profile-cleaner to reduce the size of browser profiles by organizing
      their sqlite databases using sqlite3's vacuum and reindex functions. The
      term "browser" is used loosely since profile-cleaner happily works on
      some email clients and newsreaders too.
    '';
    homepage = https://github.com/graysky2/profile-cleaner;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
