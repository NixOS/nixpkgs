{ stdenv, autoreconfHook, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  name = "moka-icon-theme-${version}";
  version = "git-20151227";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = "moka-icon-theme";
    rev = "edba1587f4b3014210ca3857bb5fbf913e9a5fd5";
    sha256 = "112k6phg62cbi669mmamb6y1avjb6qvdn49nszaq26mnwq9r80jk";
  };

  buildInputs = [ autoreconfHook pkgconfig ];

  configureScript = "sh ./autogen.sh";

  makeFlags = "DESTDIR=$(out)";

  meta = {
    description = "Moka Icon Theme";
    license = stdenv.lib.licenses.cc-by-sa-40;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jgillich ];
  };
}
