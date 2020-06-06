{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "16grd03r41n0vj5fs7j6jk395zs2q0i878p9nh1ycicy64nzmxky";
  };

  vendorSha256 = "1915h1hi2y2sx5jvx84c1j281zaz100gbhyalvg5jqjr1van5s4d";

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}