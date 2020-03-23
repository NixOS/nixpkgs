{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "0jvizj616rsh3aw9z3bijk7ixpbnqmm3xqmdxznjzqd46avr54c3";
  };

  modSha256 = "12x3m5bjyx3blh5i51pd99phv73m96pmm6i3ir4vf2kms3viif9i";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = https://github.com/amacneil/dbmate;
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
