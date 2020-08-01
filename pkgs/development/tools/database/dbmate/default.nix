{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "0v00k658b4ca9bpn2yiiy3gq5gr6hms8mlk31wf8svwsjyzjibzr";
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
