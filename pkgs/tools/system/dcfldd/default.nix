{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dcfldd";
  version = "1.3.4-1";

  src = fetchurl {
    url = "mirror://sourceforge/dcfldd/dcfldd-${version}.tar.gz";
    sha256 = "1y6mwsvm75f5jzxsjjk0yhf8xnpmz6y8qvcxfandavx59lc3l57m";
  };

  buildInputs = [ ];

  meta = with lib; {
    description = "Enhanced version of GNU dd";

    homepage = "https://dcfldd.sourceforge.net/";

    license = licenses.gpl2Plus;

    platforms = platforms.all;
    maintainers = with maintainers; [ qknight ];
    mainProgram = "dcfldd";
  };
}
