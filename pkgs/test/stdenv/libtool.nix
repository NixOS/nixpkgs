{
  stdenv,
  autoreconfHook,
  lib,
  outOfSource ? false,
  readOnlySource ? false,
  parentAuxiliary ? false,
}:

assert readOnlySource -> outOfSource;
assert parentAuxiliary -> outOfSource && !readOnlySource;

stdenv.mkDerivation (
  {
    name = "test-libtool-finishing${lib.optionalString outOfSource "-out-of-source"}${lib.optionalString readOnlySource "-readonly"}${lib.optionalString parentAuxiliary "-parent-auxiliary"}";

    nativeBuildInputs = [ autoreconfHook ];

    unpackPhase = ''
      mkdir source
      cd source
      cat > configure.ac <<'EOF'
      AC_INIT([libtool-finishing-test], [1])
      ${lib.optionalString parentAuxiliary "AC_CONFIG_AUX_DIR([..])"}
      AM_INIT_AUTOMAKE([foreign])
      AC_PROG_CC
      LT_INIT
      AC_CONFIG_FILES([Makefile])
      AC_OUTPUT
      EOF
      cat > Makefile.am <<'EOF'
      lib_LTLIBRARIES = libalpha.la libbeta.la
      libalpha_la_SOURCES = alpha.c
      libalpha_la_LDFLAGS = -version-info 1:0:0
      libbeta_la_SOURCES = beta.c
      libbeta_la_LIBADD = libalpha.la
      libbeta_la_LDFLAGS = -version-info 1:0:0
      bin_PROGRAMS = consumer
      consumer_SOURCES = consumer.c
      consumer_LDADD = libbeta.la
      EOF
      echo 'int alpha(void) { return 40; }' > alpha.c
      echo 'int alpha(void); int beta(void) { return alpha() + 2; }' > beta.c
      echo 'int beta(void); int main(void) { return beta() != 42; }' > consumer.c
      ${lib.optionalString parentAuxiliary ''
        sourceRoot=$PWD
        mkdir subproject
        mv configure.ac Makefile.am alpha.c beta.c consumer.c subproject/
      ''}
    '';

    preConfigure = lib.optionalString outOfSource ''
      libtoolSource=$PWD
      ${lib.optionalString readOnlySource ''
        # A source symlink must be replaced without changing its external target.
        cp ltmain.sh ../original-ltmain.sh
        chmod a-w ../original-ltmain.sh
        sha256sum ../original-ltmain.sh > ../original-ltmain.sha256
        rm ltmain.sh
        ln -s ../original-ltmain.sh ltmain.sh
        chmod -R a-w .
        libtoolSourceMode=$(stat -c '%a' .)
        libtoolTemplateMode=$(stat -L -c '%a' ltmain.sh)
      ''}
      configureScript="$PWD/configure"
      mkdir ${if parentAuxiliary then "../../build" else "../build"}
      cd ${if parentAuxiliary then "../../build" else "../build"}
    '';

    postConfigure = ''
      ${lib.optionalString parentAuxiliary ''
        # Confirm configure used the parent template, not another generated copy.
        test ! -e "$sourceRoot/ltmain.sh"
        grep -Fq '# nixpkgs-libtool-parent-auxiliary-fixture' libtool
      ''}
      ${lib.optionalString readOnlySource ''
        test ! -L "$libtoolSource/ltmain.sh"
        test "$(stat -c '%a' "$libtoolSource")" = "$libtoolSourceMode"
        test "$(stat -c '%a' "$libtoolSource/ltmain.sh")" = "$libtoolTemplateMode"
        sha256sum --check ../original-ltmain.sha256
      ''}
      # Exercise both platform-finishing mechanisms without running system tools.
      sed -i libtool \
        -e "s|^finish_cmds=.*|finish_cmds='touch $PWD/finish-cmds-ran'|" \
        -e "s|^finish_eval=.*|finish_eval='touch $PWD/finish-eval-ran'|"
      grep -q '^finish_cmds=.*finish-cmds-ran' libtool
      grep -q '^finish_eval=.*finish-eval-ran' libtool
    '';

    postInstall = ''
      test ! -e finish-cmds-ran
      test ! -e finish-eval-ran
      test -L "$out/lib/libalpha.so"
      test -L "$out/lib/libbeta.so"
      test -e "$out/lib/libalpha.so"
      test -e "$out/lib/libbeta.so"

      # Finish also cleans sysroot references in .la files. Preserve that operation.
      cp "$out/lib/libbeta.la" finish.la
      sed -i finish.la -e "s|^dependency_libs=.*|dependency_libs=' -L=/lib /test-sysroot/lib/libalpha.la'|"
      cp libtool finish-libtool
      sed -i finish-libtool -e "s|^lt_sysroot=.*|lt_sysroot=/test-sysroot|"
      bash ./finish-libtool --mode=finish finish.la
      grep -q "^dependency_libs=' -L/lib /lib/libalpha.la'" finish.la
      test ! -e finish-cmds-ran
      test ! -e finish-eval-ran
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      "$out/bin/consumer"
    '';

    passthru.tests = lib.optionalAttrs (!outOfSource) (
      let
        makeTest = options: import ./libtool.nix ({ inherit stdenv autoreconfHook lib; } // options);
      in
      {
        outOfSource = makeTest { outOfSource = true; };
        parentAuxiliary = makeTest {
          outOfSource = true;
          parentAuxiliary = true;
        };
        readOnlySource = makeTest {
          outOfSource = true;
          readOnlySource = true;
        };
      }
    );

    meta.platforms = lib.platforms.linux;
  }
  // lib.optionalAttrs parentAuxiliary {
    # Mirror packages whose autoreconf phase descends into a subproject while
    # AC_CONFIG_AUX_DIR keeps the generated Libtool template in its parent.
    preAutoreconf = ''
      sourceRoot=$(readlink -e ./subproject)
      cd "$sourceRoot"
    '';
    postAutoreconf = ''
      test -f ../ltmain.sh
      test ! -e ./ltmain.sh
      # Autoreconf may install a read-only template or a symlink into the store.
      sed -i '$a# nixpkgs-libtool-parent-auxiliary-fixture' ../ltmain.sh
    '';
  }
)
