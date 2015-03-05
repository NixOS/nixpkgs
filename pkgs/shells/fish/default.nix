{ stdenv, fetchurl, ncurses, python, which, groff, gettext, man_db, bc, libiconv }:

stdenv.mkDerivation rec {
  name = "fish-${version}";
  version = "2.1.2";

  src = fetchurl {
    url = "http://fishshell.com/files/${version}/${name}.tar.gz";
    sha256 = "1pgnz5lapm4qk48a13k9698jaswybzlbz2nyc621d852ldf0vhn6";
  };

  buildInputs = [ ncurses libiconv ];

  # Required binaries during execution
  # Python: Autocompletion generated from manpages and config editing
  propagatedBuildInputs = [ python which groff gettext man_db bc ];

  postInstall = ''
    sed -i "s|bc|${bc}/bin/bc|" "$out/share/fish/functions/seq.fish"
    sed -i "s|which |${which}/bin/which |" "$out/share/fish/functions/type.fish"
    sed -i "s|nroff |${groff}/bin/nroff |" "$out/share/fish/functions/__fish_print_help.fish"
    sed -e "s|gettext |${gettext}/bin/gettext |" \
        -e "s|which |${which}/bin/which |" \
        -i "$out/share/fish/functions/_.fish"
    sed -i "s|Popen(\['manpath'|Popen(\['${man_db}/bin/manpath'|" "$out/share/fish/tools/create_manpage_completions.py"
    sed -i "s|/sbin /usr/sbin||" \
           "$out/share/fish/functions/__fish_complete_subcommand_root.fish"
  '';

  meta = with stdenv.lib; {
    description = "Smart and user-friendly command line shell";
    homepage = "http://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ocharles ];
  };
}
