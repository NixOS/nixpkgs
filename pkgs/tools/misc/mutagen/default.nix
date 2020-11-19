{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "17ycd2y7hgwa2yxbin86i6aj67x7xaajwz3mqgdyfvkja5hgbjyr";
  };

  vendorSha256 = "0szs9yc49fyh55ra1wf8zj76kdah0x49d45cgivk3gqh2hl17j6l";

  doCheck = false;

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

  meta = with lib; {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
