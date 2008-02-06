{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.32";
  src = fetchurl {
    url = mirror://gnu/findutils/findutils-4.2.32.tar.gz;
    sha256 = "05sj0154kl4mbqg7dcabiaa16snjv2ppfwwhcvl2zyn2yc28igc7";
  };
  buildInputs = [coreutils];

  patches = [ ./findutils-path.patch ./change_echo_path.patch ]
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ stdenv.lib.optional (stdenv ? isDietLibC) ./dietlibc-hack.patch;

  meta = {
    homepage = http://www.gnu.org/software/findutils/;
    description = "The basic directory searching utilities of the GNU operating system";
  };
}
