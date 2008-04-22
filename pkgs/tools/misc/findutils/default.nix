{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.33";
  src = fetchurl {
    url = mirror://gnu/findutils/findutils-4.2.33.tar.gz;
    sha256 = "0y0gmdc55kknf5438c1da5xsvpch3v800r79rgz5rv6fb90djg41";
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
