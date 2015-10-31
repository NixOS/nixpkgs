{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "mates-${version}";
  version = "0.1.0";

  depsSha256 = "03mqw9zs3hbsgz8m3qbrbbcg2q47nldfx280dyv0ivfksnlc7lyc";

  src = fetchFromGitHub {
    owner = "untitaker";
    repo = "mates";
    rev = "${version}";
    sha256 = "00dpl7vh2byb4v94zxjbcqj7jnq65vcbrlpkxrrii0ip13dr69pw";
  };

  meta = with stdenv.lib; {
    description = "Very simple commandline addressbook";
    homepage = https://github.com/untitaker/mates.rs;
    license = stdenv.lib.licenses.mit;
    maintainers = [ maintainers.DamienCassou ];
  };
}
