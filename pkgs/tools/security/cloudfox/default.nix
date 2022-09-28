{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JwSXm75CC1GBbQ7kZJXyDXf2997owRaGcB2m7q+BrEs=";
  };

  vendorSha256 = "sha256-KrJR5YZxP6psHphY0BhYFu14PaDi5k1ngFfYPSzOYK4=";

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
