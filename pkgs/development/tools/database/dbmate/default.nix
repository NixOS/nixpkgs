{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "0s7ymw1r1k1s8kwyg6nxpgak6kh9z3649a0axdfpjnm62v283shd";
  };

  vendorSha256 = "00vp925vf9clk5bkw5fvj34id4v548rlssizh52z9psvdizj8q5p";

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
