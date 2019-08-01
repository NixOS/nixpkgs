{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yk5hygrjkbq5ry2kark3hd59hwjxpgryz0ychr8mhzvlr97aj1k";
  };

  modSha256 = "096hq0xc3cq45r13pm0s0q9rxd4z0ia6x0wy4xmwgzfb97jvn20p";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
