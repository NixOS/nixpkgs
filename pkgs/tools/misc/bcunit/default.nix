{stdenv, fetchFromGitHub, cmake}:
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "bcunit";
  version = "3.0.2";
  buildInputs = [cmake];
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = baseName;
    rev = version;
    sha256 = "063yl7kxkix76r49qrj0h1qpz2p538d1yw8aih0x4i47g35k00y7";
  };

  meta = {
    inherit version;
    description = ''A fork of CUnit test framework'';
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

