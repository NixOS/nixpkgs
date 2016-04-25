{ stdenv, fetchFromGitHub, autoreconfHook, gtk3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "theme-vertex-${version}";
  version = "20160329";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "Vertex-theme";
    rev = version;
    sha256 = "1zafnbxn9hgi4lmi254iw9jyhifcqijxa7cymwjpyy0jfa6sm1qj";
  };

  buildInputs = [ autoreconfHook gtk3 pkgconfig ];

  configureFlags = "--disable-unity";

  postInstall = ''
    mkdir -p $out/share/doc/theme-vertex
    cp AUTHORS COPYING README.md $out/share/doc/theme-vertex/

    mkdir -p $out/share/doc/theme-vertex/extra
    cp -r extra/{Chrome,Firefox} $out/share/doc/theme-vertex/extra
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Theme for GTK 3, GTK 2, Gnome-Shell, and Cinnamon";
    license = licenses.gpl3;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
  };
}
