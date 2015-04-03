{ stdenv, fetchFromGitHub, makeWrapper, parallel, sqlite }:

stdenv.mkDerivation rec {
  version = "2.34";
  name = "profile-cleaner-${version}";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-cleaner";
    rev = "v${version}";
    sha256 = "17z73xyn31668f7vmbj7xs659fcrm0m0mnzja7hz6lipfaviqxrs";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    wrapProgram $out/bin/profile-cleaner \
      --prefix PATH : "${parallel}/bin:${sqlite}/bin"
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
