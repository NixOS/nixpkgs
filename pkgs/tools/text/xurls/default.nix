{ buildGoPackage, lib, fetchFromGitHub }:

buildGoPackage rec {
  version = "2.3.0";
  pname = "xurls";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "sha256-+oWYW7ZigkNS6VADNmVwarIsYyd730RAdDwnNIAYvlA=";
  };

  goPackagePath = "mvdan.cc/xurls/v2";
  subPackages = [ "cmd/xurls" ];

  meta = with lib; {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
