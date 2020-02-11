{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "18wjzylxypvisfdmmwqc8g9vd9w7iyhs8irad1ksf7fhwz9w188m";
  };

  modSha256 = "0zb6wqfgp5v0hpm8ad6s9lc1n3wayyqindv4vfkmp3980ikb8qwx";

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

  meta = with lib; {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
