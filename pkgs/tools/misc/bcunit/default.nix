{stdenv, fetchFromGitHub, cmake}:
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "bcunit";
  version = "3.0";
  buildInputs = [cmake];
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "1kdq9w8i3nypfz7d43rmv1csqrqpip9p8xfa7vyp52aqkmhrby9l";
  };

  meta = {
    inherit version;
    description = ''A fork of CUnit test framework'';
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

