{ stdenv, fetchurl, ncurses, nettools, python, which, groff, gettext, man_db,
  bc, libiconv, coreutils, gnused, kbd, utillinux, glibc }:

stdenv.mkDerivation rec {
  name = "fish-${version}";
  version = "2.2.0";

  patches = [ ./etc_config.patch ./builtin_status.patch ./command-not-found.patch ];

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
    sed -e "s|expr|${coreutils}/bin/expr|" \
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
        -e "s|if which unicode_start|if true|" \
        -e "s|unicode_start|${kbd}/bin/unicode_start|" \
  '' + ''
        -i "$out/etc/fish/config.fish"
    sed -e "s|bc|${bc}/bin/bc|" \
        -e "s|/usr/bin/seq|${coreutils}/bin/seq|" \
        -i "$out/share/fish/functions/seq.fish" \
           "$out/share/fish/functions/math.fish"
    sed -i "s|which |${which}/bin/which |" "$out/share/fish/functions/type.fish"
    sed -e "s|\|cut|\|${coreutils}/bin/cut|" -i "$out/share/fish/functions/fish_prompt.fish"
    sed -i "s|nroff |${groff}/bin/nroff |" "$out/share/fish/functions/__fish_print_help.fish"
    sed -e "s|gettext |${gettext}/bin/gettext |" \
        -e "s|which |${which}/bin/which |" \
        -i "$out/share/fish/functions/_.fish"
    sed -e "s|uname|${coreutils}/bin/uname|" \
        -i "$out/share/fish/functions/__fish_pwd.fish" \
           "$out/share/fish/functions/prompt_pwd.fish"
    sed -e "s|sed |${gnused}/bin/sed |" \
        -i "$out/share/fish/functions/alias.fish" \
           "$out/share/fish/functions/prompt_pwd.fish"
    substituteInPlace "$out/share/fish/functions/fish_default_key_bindings.fish" \
      --replace "clear;" "${ncurses}/bin/clear;"
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace "$out/share/fish/functions/__fish_print_help.fish" \
      --replace "| ul" "| ${utillinux}/bin/ul" 

    for cur in $out/share/fish/functions/*.fish; do
      substituteInPlace "$cur" --replace "/usr/bin/getent" "${glibc}/bin/getent" 
    done
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    sed -i "s|(hostname\||(${nettools}/bin/hostname\||" "$out/share/fish/functions/fish_prompt.fish"
    sed -i "s|Popen(\['manpath'|Popen(\['${man_db}/bin/manpath'|" "$out/share/fish/tools/create_manpage_completions.py"
    sed -i "s|command manpath|command ${man_db}/bin/manpath|" "$out/share/fish/functions/man.fish"
  '' + ''
    sed -i "s|/sbin /usr/sbin||" \
           "$out/share/fish/functions/__fish_complete_subcommand_root.fish"

    # make fish pick up completions from nix profile
    echo "set fish_complete_path (echo \$NIX_PROFILES | tr ' ' '\n')\"/share/fish/vendor_completions.d\" \$fish_complete_path" >> $out/share/fish/config.fish
  '';

  meta = with stdenv.lib; {
    description = "Smart and user-friendly command line shell";
    homepage = "http://fishshell.com/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ocharles ];
  };
}
