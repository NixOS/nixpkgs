{ buildGoPackage, stdenv, fetchFromGitHub }:

buildGoPackage rec {
  version = "2.2.0";
  pname = "xurls";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "0w7i1yfl5q24wvmsfb3fz1zcqsdh4c6qikjnmswxbjc7wva8rngg";
  };

  goPackagePath = "mvdan.cc/xurls/v2";
  subPackages = [ "cmd/xurls" ];

  meta = with stdenv.lib; {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
