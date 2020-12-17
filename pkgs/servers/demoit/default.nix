{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "demoit";
  version = "unstable-2020-06-11";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "5762b169e7f2fc18913874bf52323ffbb906ce84";
    sha256 = "1jcjqr758d29h3y9ajvzhy1xmxfix5mwhylz6jwhy5nmk28bjzx9";
  };
  vendorSha256 = null;
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Live coding demos without Context Switching";
    homepage = "https://github.com/dgageot/demoit";
    license = licenses.asl20;
    maintainers = [ maintainers.freezeboy ];
  };
}
