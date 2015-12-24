{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "mates-${version}";
  version = "0.1.0";

  depsSha256 = "0h8i4y7fr57k31s0m4c5dyzwim6y9f01rljvh2kjpnff97fc25xx";

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
