{ stdenv, fetchFromGitHub, bzip2, yacc, flex }:

let version = "1.6.16"; in

stdenv.mkDerivation rec {
  name = "nfdump-${version}";

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev = "v${version}";
    sha256 = "0dgrzf9m4rg5ygibjw21gjdm9am3570wys7wdh5k16nsnyai1gqm";
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
