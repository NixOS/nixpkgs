{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kapow";
  version = "0.5.4";

  goPackagePath = "github.com/BBVA/kapow";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "BBVA";
    repo = pname;
    rev = "v${version}";
    sha256 = "09qr631vzlgibz6q64f35lqzz9h1g3gxqfbapkrci5i0n3h04yr4";
  };

  vendorSha256 = "159s46rhg67mgglaxgddx3k8kssl0cqiq8yjdqgjhhxppf16r7dy";

  meta = with stdenv.lib; {
    homepage = "https://github.com/BBVA/kapow";
    description = "Expose command-line tools over HTTP";
    license = licenses.asl20;
    maintainers = with maintainers; [ nilp0inter ];
  };
}
