{ stdenv, fetchurl, autoconf, ncurses, which, groff, gettext }:

stdenv.mkDerivation rec {
  name = "fish-2.1.0";

  src = fetchurl {
    url = http://fishshell.com/files/2.1.0/fish-2.1.0.tar.gz;
    sha1 = "b1764cba540055cb8e2a96a7ea4c844b04a32522";
  };

  nativeBuildInputs = [ autoconf ];

  buildInputs = [ ncurses which ];

  preConfigure = ''
    autoconf
  '';

  postInstall = ''
    sed -i "s|which |command -v |" "$out/share/fish/functions/type.fish"
    sed -i "s|nroff |${groff}/bin/nroff |" "$out/share/fish/functions/__fish_print_help.fish"
    sed -e "s|gettext |${gettext}/bin/gettext |" \
        -e "s|which |command -v |" \
        -i "$out/share/fish/functions/_.fish"
  '';

  meta = with stdenv.lib; {
    description = "Smart and user-friendly command line shell";
    homepage = http://fishshell.com/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
