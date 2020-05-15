{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yq-go";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = version;
    repo = "yq";
    sha256 = "1jll5nmskvs61031h3sizhv3scv8znrr9apyc4qlxcp4jiv7xpmp";
  };

  vendorSha256 = "0rlvbyhl53x1bhwr7f7zs4swa580saak19z3d3g58srq3jyw6zlc";

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}