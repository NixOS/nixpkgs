{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yq-go";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = version;
    repo = "yq";
    sha256 = "1n20m1zizbkgzag4676fvf16h6f8vll6pniblj7haqdwvnza8zwd";
  };

  modSha256 = "0hbazc6hf3zrni25lpbyi36sbxyabbrpi591gkqwxgr9hdbdpcg9";

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
