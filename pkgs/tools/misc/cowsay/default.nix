{ stdenv, fetchgit, perl }:

stdenv.mkDerivation {
  name = "cowsay-3.03+dfsg1-16";

  src = fetchgit {
    url = https://anonscm.debian.org/git/collab-maint/cowsay.git;
    rev = "acb946c166fa3b9526b9c471ef1330f9f89f9c8b";
    sha256 = "1ji66nrdcc8sh79hwils3nbaj897s352r5wp7kzjwiym8bm2azk6";
  };

  buildInputs = [ perl ];

  installPhase = ''
    bash ./install.sh $out
  '';

  meta = {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = http://www.nog.net/~tony/warez/cowsay.shtml;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rob ];
  };
}
