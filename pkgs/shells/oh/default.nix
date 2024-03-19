{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "oh";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "michaelmacinnis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ryIh6MRIOVZPm2USpJC69Z/upIXGUHgcd17eZBA9Edc=";
  };

  vendorHash = "sha256-Qma5Vk0JO/tTrZanvTCE40LmjeCfBup3U3N7gyhfp44=";

  meta = with lib; {
    homepage = "https://github.com/michaelmacinnis/oh";
    description = "A new Unix shell";
    mainProgram = "oh";
    license = licenses.mit;
  };

  passthru = {
    shellPath = "/bin/oh";
  };
}
