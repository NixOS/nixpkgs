{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kapow";
  version = "0.5.3";

  goPackagePath = "github.com/BBVA/kapow";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "BBVA";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m5b9lvg5d908d27khyx9p3567pap1b2mxl8fk7cxhb51r89jypj";
  };

  vendorSha256 = "159s46rhg67mgglaxgddx3k8kssl0cqiq8yjdqgjhhxppf16r7dy";

  meta = with stdenv.lib; {
    homepage = "https://github.com/BBVA/kapow";
    description = "Expose command-line tools over HTTP";
    license = licenses.asl20;
    maintainers = with maintainers; [ nilp0inter ];
  };
}
