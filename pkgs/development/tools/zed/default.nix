{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ias2HKwZo5Q/0M4YZI4wLgzMVWmannruXlhp8IsOuyU=";
  };

  vendorHash = "sha256-h5NYx6xhIh4i/tS5cGHXBomnVZCUn8jJuzL6k1+IdKk=";

  subPackages = [ "cmd/zed" "cmd/zq" ];

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://github.com/brimdata/zed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
  };
}
