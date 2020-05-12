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

  modSha256 = "1ky6cxpmw93nrk26vyrxz8kqa7247axzaxilm6ciypxf30ad0vdq";

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
