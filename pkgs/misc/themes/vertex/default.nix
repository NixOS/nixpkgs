{ stdenv, fetchFromGitHub, autoreconfHook, gtk3, pkgconfig }:

stdenv.mkDerivation rec {
  name = "theme-vertex-${version}";
  version = "20150718";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "Vertex-theme";
    rev = version;
    sha256 = "19mmybfkx3mrbm9vr78c7xiyazmyzji1n6669466svjr3jy87546";
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
    maintainer = [ maintainers.rycee ];
    platforms = platforms.unix;
  };
}
