{ stdenv, lib, fetchurl, libiconv, gettext-runtime, libtextstyle,
  makeSetupHook, autoconf, automake, libtool
}:


let common = import ../../libraries/gettext/common.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "gettext-tools";
  inherit (common) version src;

  sourceRoot = "${common.pname}-${common.version}/${pname}/";

  # Sources are within a subdir of the upstream directory. Given
  # that patches are applied from sourceRoot, we cannot just
  # fetch patches upstream in order to backport them. We have
  # to update them to accomodate the effective root.
  patches = [
    # Originaly commited in d9e4fc31ea7728b39c1ff2f2963e4f3df716b6b7:
    # gettext 0.20 fixed a bug with handling locale on macOS, but this caused
    # it to report an annoying warning on systems where “language”
    # differs from “region”. See Homebrew issue for details:
    # <https://github.com/Homebrew/homebrew-core/issues/41139>.
    # See also
    # <https://www.mail-archive.com/bug-gnulib@gnu.org/msg36768.html>.
    ./gettext.git-2336451ed68d91ff4b5ae1acbc1eca30e47a86a9.patch

    # TODO when upgrading from 0.20.1
    #
    #   - remove the this patch (this is an updated backport from upstream)
    #   - remove the makeSetupHook and and its dependencies (autoconf, automake, libtool)
    #   - remove the 'cp ../libtextstyle/m4/libtextstyle.m4 gnulib-m4/' from postPach
    ./restore_the_ability_to_build_gettext-tools_separately.patch
  ];

  outputs = [ "out" "man" "doc" "info" ];

  configureFlags = [
    "--disable-csharp"
    "--with-xz"
    "--with-installed-libtextstyle"
  ];

  postPatch = ''
   cp ../libtextstyle/m4/libtextstyle.m4 gnulib-m4/
   substituteInPlace projects/KDE/trigger --replace "/bin/pwd" pwd
   substituteInPlace projects/GNOME/trigger --replace "/bin/pwd" pwd
   substituteInPlace src/project-id --replace "/bin/pwd" pwd
  '' + lib.optionalString stdenv.hostPlatform.isCygwin ''
    sed -i -e "s/\(cldr_plurals_LDADD = \)/\\1..\/gnulib-lib\/libxml_rpl.la /" src/Makefile.in
    sed -i -e "s/\(libgettextsrc_la_LDFLAGS = \)/\\1..\/gnulib-lib\/libxml_rpl.la /" src/Makefile.in
  '';

  nativeBuildInputs = [
    # This is basically autoreconfHook, but without gettext-tools in deps
    # to avoid circular dependency
    (makeSetupHook {
      deps = [ autoconf automake libtool ]; }
      ../../../build-support/setup-hooks/autoreconf.sh
    )
  ];

  buildInputs = [
    gettext-runtime
    libtextstyle
  ] # HACK, see #10874 (and 14664)
    ++ stdenv.lib.optional (!stdenv.isLinux && !stdenv.hostPlatform.isCygwin) libiconv;

  setupHooks = [
    ../../../build-support/setup-hooks/role.bash
    ./gettext-setup-hook.sh
  ];

  enableParallelBuilding = true;
  enableParallelChecking = false; # fails sometimes

  meta = with lib; {
    description = "Well integrated set of translation tools and documentation";

    longDescription = ''
      Usually, programs are written and documented in English, and use
      English at execution time for interacting with users.  Using a common
      language is quite handy for communication between developers,
      maintainers and users from all countries.  On the other hand, most
      people are less comfortable with English than with their own native
      language, and would rather be using their mother tongue for day to
      day's work, as far as possible.  Many would simply love seeing their
      computer screen showing a lot less of English, and far more of their
      own language.

      GNU `gettext' is an important step for the GNU Translation Project, as
      it is an asset on which we may build many other steps. This package
      offers to programmers, translators, and even users, a well integrated
      set of tools and documentation. Specifically, the GNU `gettext'
      utilities are a set of tools that provides a framework to help other
      GNU packages produce multi-lingual messages.
    '';

    homepage = https://www.gnu.org/software/gettext/;

    maintainers = with maintainers; [ zimbatm vrthra lsix ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
