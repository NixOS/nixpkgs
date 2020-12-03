{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pbgopy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = pname;
    rev = "v${version}";
    sha256 = "17rk15hs7kg9m1vphh1gjny7sqnk80qw61jn8qyxcmw2n55rkmfp";
  };

  vendorSha256 = "1ak3hd979395grbns9p5sw5f45plcqq6vg7j7v8n7xqc20s2l8m9";

  meta = with stdenv.lib; {
    description = "Copy and paste between devices";
    homepage = "https://github.com/nakabonne/pbgopy";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
  };
}
