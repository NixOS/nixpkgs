{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "certigo";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vi4gn484kc7vyxnm2nislzy587h2h4gc8d197vslhyfygac9y7b";
  };

  goPackagePath = "github.com/square/certigo";

  meta = with stdenv.lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
