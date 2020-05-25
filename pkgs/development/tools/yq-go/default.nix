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

  modSha256 = "1m7sha6kwis1a00il1iigb9lxxh5m2myj9ps20s816m0b9bhd43v";

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
