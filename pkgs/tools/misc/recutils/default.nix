{ fetchurl, stdenv, gettext, emacs, curl, check, bc }:

stdenv.mkDerivation rec {
  name = "recutils-1.4";

  src = fetchurl {
    url = "mirror://gnu/recutils/${name}.tar.gz";
    sha256 = "1kakmzmkdkgqmvqfzrpkwjjkg492rk3k7xfgnwcjacap9l79z9pv";
  };

  doCheck = true;

  buildInputs = [ curl emacs ] ++ (stdenv.lib.optionals doCheck [ check bc ]);

  meta = {
    description = "GNU Recutils, tools and libraries to access human-editable, text-based databases";

    longDescription =
      '' GNU Recutils is a set of tools and libraries to access
         human-editable, text-based databases called recfiles.  The data is
         stored as a sequence of records, each record containing an arbitrary
         number of named fields.
      '';

    homepage = http://www.gnu.org/software/recutils/;

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
