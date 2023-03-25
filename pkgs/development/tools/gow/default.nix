{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gow";
  version = "unstable-2023-02-08";

  src = fetchFromGitHub {
    owner = "mitranim";
    repo = pname;
    rev = "36c8536a96b851631e800bb00f73383fc506f210";
    sha256 = "sha256-q56s97j+Npurb942TeQhJPqq1vl/XFe7a2Dj5fw7EtQ=";
  };

  vendorSha256 = "sha256-o6KltbjmAN2w9LMeS9oozB0qz9tSMYmdDW3CwUNChzA=";

  tags = [ "mitranim" "gow" "go" "golang" "file" "watch" "watcher" "gowatch" "go-watch" ];

  meta = with lib; {
    homepage = "https://github.com/mitranim/gow";
    description = "Missing watch mode for Go commands";
    maintainers = with maintainers; [ v3s1e ];
    license = licenses.unlicense;
  };
}
