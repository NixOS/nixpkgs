{ stdenv, fetchurl, perl, gmp ? null
, aclSupport ? false, acl ? null
, selinuxSupport? false, libselinux ? null, libsepol ? null
, autoconf, automake114x, texinfo
, withPrefix ? false
}:

assert aclSupport -> acl != null;
assert selinuxSupport -> libselinux != null && libsepol != null;


with { inherit (stdenv.lib) optional optionals optionalString optionalAttrs; };

let
  self = stdenv.mkDerivation rec {
    name = "coreutils-8.24";

    src = fetchurl {
      url = "mirror://gnu/coreutils/${name}.tar.xz";
      sha256 = "0w11jw3fb5sslf0f72kxy7llxgk1ia3a6bcw0c9kmvxrlj355mx2";
    };

    # FIXME needs gcc 4.9 in bootstrap tools
    hardening_stackprotector = false;

    patches = if stdenv.isCygwin then ./coreutils-8.23-4.cygwin.patch else
              (if stdenv.isArm then (fetchurl {
                  url = "http://git.savannah.gnu.org/cgit/coreutils.git/patch/?id=3ba68f9e64fa2eb8af22d510437a0c6441feb5e0";
                  sha256 = "1dnlszhc8lihhg801i9sz896mlrgfsjfcz62636prb27k5hmixqz";
                  name = "coreutils-tail-inotify-race.patch";
              }) else null);

    # The test tends to fail on btrfs and maybe other unusual filesystems.
    postPatch = stdenv.lib.optionalString (!stdenv.isDarwin) ''
      sed '2i echo Skipping dd sparse test && exit 0' -i ./tests/dd/sparse.sh
      sed '2i echo Skipping cp sparse test && exit 0' -i ./tests/cp/sparse.sh
    '' +
       # This is required by coreutils-tail-inotify-race.patch to avoid more deps
       stdenv.lib.optionalString stdenv.isArm ''
         touch -r src/stat.c src/tail.c
       '';

    configureFlags = optionalString stdenv.isSunOS "ac_cv_func_inotify_init=no";

    nativeBuildInputs = [ perl ];
    buildInputs = [ gmp ]
      ++ optional aclSupport acl
      ++ optionals stdenv.isCygwin [ autoconf automake114x texinfo ]   # due to patch
      ++ optionals selinuxSupport [ libselinux libsepol ];

    crossAttrs = {
      buildInputs = [ gmp.crossDrv ]
        ++ optional aclSupport acl.crossDrv
        ++ optionals selinuxSupport [ libselinux.crossDrv libsepol.crossDrv ]
        ++ optional (stdenv.ccCross.libc ? libiconv)
          stdenv.ccCross.libc.libiconv.crossDrv;

      buildPhase = ''
        make || (
          pushd man
          for a in *.x; do
            touch `basename $a .x`.1
          done
          popd; make )
      '';

      postInstall = ''
        rm $out/share/man/man1/*
        cp ${self}/share/man/man1/* $out/share/man/man1
      '';

      # Needed for fstatfs()
      # I don't know why it is not properly detected cross building with glibc.
      configureFlags = [ "fu_cv_sys_stat_statfs2_bsize=yes" ];
      doCheck = false;
    };

    # The tests are known broken on Cygwin
    # (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19025),
    # Darwin (http://thread.gmane.org/gmane.comp.gnu.core-utils.bugs/19351),
    # and {Open,Free}BSD.
    doCheck = stdenv ? glibc;

    # Saw random failures like ‘help2man: can't get '--help' info from
    # man/sha512sum.td/sha512sum’.
    enableParallelBuilding = false;

    NIX_LDFLAGS = optionalString selinuxSupport "-lsepol";
    FORCE_UNSAFE_CONFIGURE = stdenv.lib.optionalString (stdenv.system == "armv7l-linux" || stdenv.isSunOS) "1";

    makeFlags = optionalString stdenv.isDarwin "CFLAGS=-D_FORTIFY_SOURCE=0";

    # e.g. ls -> gls; grep -> ggrep
    postFixup = # feel free to simplify on a mass rebuild
      if withPrefix then
      ''
        (
          cd "$out/bin"
          find * -type f -executable -exec mv {} g{} \;
        )
      ''
      else null;

    meta = {
      homepage = http://www.gnu.org/software/coreutils/;
      description = "The basic file, shell and text manipulation utilities of the GNU operating system";

      longDescription = ''
        The GNU Core Utilities are the basic file, shell and text
        manipulation utilities of the GNU operating system.  These are
        the core utilities which are expected to exist on every
        operating system.
      '';

      license = stdenv.lib.licenses.gpl3Plus;

      platforms = stdenv.lib.platforms.all;

      maintainers = [ stdenv.lib.maintainers.eelco ];
    };
  };
in
  self
