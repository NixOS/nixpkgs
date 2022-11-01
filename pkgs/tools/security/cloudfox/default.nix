{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eWo5l3yFEW7ztyYvN1zGGOhCzkJW7rUqaQ+2BPB7BWY=";
  };

  vendorSha256 = "sha256-ATHQUvUBDZh06LtWLAA1UyHU1c4LME0z/FsygQQJQy8=";

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
