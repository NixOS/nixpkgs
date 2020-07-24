{ stdenv, fetchFromGitHub, makeWrapper, parallel, sqlite, bc, file }:

stdenv.mkDerivation rec {
  version = "2.41";
  pname = "profile-cleaner";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-cleaner";
    rev = "v${version}";
    sha256 = "11sjf4j9dr6ih9jkg6vqq6gkfg6wly4182bi1008bsm1zdmm5iz7";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    wrapProgram $out/bin/profile-cleaner \
      --prefix PATH : "${stdenv.lib.makeBinPath [ parallel sqlite bc file ]}"
  '';

  meta = {
    description = "Reduces browser profile sizes by cleaning their sqlite databases";
    longDescription = ''
      Use profile-cleaner to reduce the size of browser profiles by organizing
      their sqlite databases using sqlite3's vacuum and reindex functions. The
      term "browser" is used loosely since profile-cleaner happily works on
      some email clients and newsreaders too.
    '';
    homepage = "https://github.com/graysky2/profile-cleaner";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
