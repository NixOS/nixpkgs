{ stdenv, fetchurl, ncurses, python27, which, groff, gettext, man_db, bc }:

stdenv.mkDerivation rec {
  name = "fish-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://fishshell.com/files/${version}/${name}.tar.gz";
    sha256 = "0i7h3hx8iszli3d4kphw79sz9m07f2lc2c9hr9smdps5s7wpllmg";
  };

  buildInputs = [ ncurses ];

  # Required binaries during execution
  # Python27: Autocompletion generated from manpages and config editing
  propagatedBuildInputs = [ python27 which groff gettext man_db bc ];

  postInstall = ''
    sed -i "s|bc|${bc}/bin/bc|" "$out/share/fish/functions/seq.fish"
    sed -i "s|which |${which}/bin/which |" "$out/share/fish/functions/type.fish"
    sed -i "s|nroff |${groff}/bin/nroff |" "$out/share/fish/functions/__fish_print_help.fish"
    sed -e "s|gettext |${gettext}/bin/gettext |" \
        -e "s|which |${which}/bin/which |" \
        -i "$out/share/fish/functions/_.fish"
    sed -i "s|Popen(\['manpath'|Popen(\['${man_db}/bin/manpath'|" "$out/share/fish/tools/create_manpage_completions.py"
  '';

  meta = with stdenv.lib; {
    description = "Smart and user-friendly command line shell";
    homepage = "http://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocharles ];
  };
}
