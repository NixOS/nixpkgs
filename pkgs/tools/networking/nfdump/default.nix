{ stdenv, fetchFromGitHub, bzip2, yacc, flex }:

let version = "1.6.15"; in

stdenv.mkDerivation rec {
  name = "nfdump-${version}";

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev = "v${version}";
    sha256 = "07grsfkfjy05yfqfcmgp5xpavpck9ps6q7x8x8j79fym5d8gwak5";
  };

  nativeBuildInputs = [yacc flex];
  buildInputs = [bzip2];

  meta = with stdenv.lib; {
    description = "Tools for working with netflow data";
    longDescription = ''
      nfdump is a set of tools for working with netflow data.
    '';
    homepage = https://github.com/phaag/nfdump;
    license = licenses.bsd3;
    maintainers = [ maintainers.takikawa ];
    platforms = platforms.unix;
  };
}
