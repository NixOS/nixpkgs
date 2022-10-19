{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QntRCiY6le3gCuWoNT27WD/p4huxjCDFb24Sj/8luMs=";
  };

  vendorSha256 = "sha256-89VQ7RH2TTYME+fH1S0KHAIfUYXV6Oi72kz70JVBXTs=";

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
