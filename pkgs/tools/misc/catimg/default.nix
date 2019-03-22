{ stdenv, fetchFromGitHub, cmake } :

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "catimg";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "posva";
    repo = pname;
    rev = version;
    sha256 = "0n74iczzgxrcq3zpa7ndycb9rinm829yvf81c747q4ngv5q6pzcm";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    license = licenses.mit;
    homepage = "https://github.com/posva/catimg";
    description = "Insanely fast image printing in your terminal";
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };

}
