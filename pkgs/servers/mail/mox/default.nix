{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mox";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "mjl-";
    repo = "mox";
    rev = "v${version}";
    hash = "sha256-QDDNWGuDWxUBdoYEHQC7Ug0i8NyaqqGVsmFtTWfiM0M=";
  };

  # set the version during buildtime
  patches = [ ./version.patch ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mjl-/mox/moxvar.Version=${version}"
  ];

  meta = {
    description = "Modern full-featured open source secure mail server for low-maintenance self-hosted email";
    homepage = "https://github.com/mjl-/mox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
