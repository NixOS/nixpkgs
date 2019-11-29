{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation {
  pname = "pgjwt";
  version = "unstable-2017-04-24";

  src = fetchFromGitHub {
    owner  = "michelp";
    repo   = "pgjwt";
    rev    = "546a2911027b716586e241be7fd4c6f1785237cd";
    sha256 = "1riz0xvwb6y02j0fljbr9hcbqb2jqs4njlivmavy9ysbcrrv1vrf";
  };

  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/share/postgresql/extension
    cp pg*sql *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "PostgreSQL implementation of JSON Web Tokens";
    longDescription = ''
      sign() and verify() functions to create and verify JSON Web Tokens.
    '';
    license = licenses.mit;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [spinus];
  };
}
