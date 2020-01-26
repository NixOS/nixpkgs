{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y1bvk93dzsxwjakmgpb5qyy3lqng7cdabi64b555c1z6b42mf58";
  };

  modSha256 = "00d0wjnr5y3bl95lma8sdwvqqs7fd0k43azawp1kb29kqnrlismg";

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://circleci.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
