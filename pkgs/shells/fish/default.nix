{ stdenv, fetchurl, ncurses, python, which, groff, gettext, man_db, bc, libiconv, coreutils }:

stdenv.mkDerivation rec {
  name = "fish-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "http://fishshell.com/files/${version}/${name}.tar.gz";
    sha256 = "0ympqz7llmf0hafxwglykplw6j5cz82yhlrw50lw4bnf2kykjqx7";
  };

  buildInputs = [ ncurses libiconv ];

  # Required binaries during execution
  # Python: Autocompletion generated from manpages and config editing
  propagatedBuildInputs = [ python which groff gettext ]
                          ++ stdenv.lib.optional (!stdenv.isDarwin) man_db
                          ++ [ bc coreutils ];

  postInstall = ''
    sed -e "s|bc|${bc}/bin/bc|" \
        -e "s|/usr/bin/seq|${coreutils}/bin/seq|" \
        -i "$out/share/fish/functions/seq.fish" \
           "$out/share/fish/functions/math.fish"
    sed -i "s|which |${which}/bin/which |" "$out/share/fish/functions/type.fish"
    sed -i "s|nroff |${groff}/bin/nroff |" "$out/share/fish/functions/__fish_print_help.fish"
    sed -e "s|gettext |${gettext}/bin/gettext |" \
        -e "s|which |${which}/bin/which |" \
        -i "$out/share/fish/functions/_.fish"
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    sed -i "s|Popen(\['manpath'|Popen(\['${man_db}/bin/manpath'|" "$out/share/fish/tools/create_manpage_completions.py"
  '' + ''
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
