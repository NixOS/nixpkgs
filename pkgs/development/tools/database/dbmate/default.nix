{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "09zb7r8f6m1w9ax9ayaxjzwmqcgx5f6x4lclfi1wdn6f6qaans4w";
  };

  vendorSha256 = "012kgdvw7hj3m40v3nnpg916n02nxv19zid07h8g4qwprzg49iq2";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
