{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pbgopy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = pname;
    rev = "v${version}";
    sha256 = "0impgx9w9lk93b7p1vhjnbslr04655fn6csx7hj04kffzhyb3p1q";
  };

  vendorSha256 = "09hn92bi2rmixpsgckbi8f70widls40fwqqm7y7rqglyjqi7rdmw";

  meta = with lib; {
    description = "Copy and paste between devices";
    homepage = "https://github.com/nakabonne/pbgopy";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
  };
}
