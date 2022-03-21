{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gost";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "ginuerzh";
    repo = "gost";
    rev = "v${version}";
    sha256 = "1mxgjvx99bz34f132827bqk56zgvh5rw3h2xmc524wvx59k9zj2a";
  };

  vendorSha256 = "1cgb957ipkiix3x0x84c77a1i8l679q3kqykm1lhb4f19x61dqjh";

  # Many tests fail.
  doCheck = false;

  meta = with lib; {
    description = "A simple tunnel written in golang";
    homepage = "https://github.com/ginuerzh/gost";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
  };
}
