{stdenv, fetchurl, aclSupport ? false, acl, perl}:

stdenv.mkDerivation rec {
  name = "coreutils-8.1";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "1c68q4c4fg6x22ba2p8xb0ddn4xdl847np2g33h63bgj9pdav8ay";
  };

  buildInputs = [ perl ] ++ stdenv.lib.optional aclSupport acl;

  # The check failed the last time we enabled it
  doCheck = false;

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";

    longDescription = ''
      The GNU Core Utilities are the basic file, shell and text
      manipulation utilities of the GNU operating system.  These are
      the core utilities which are expected to exist on every
      operating system.
    '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
