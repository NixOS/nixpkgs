{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zdns";
  version = "2022-03-14-unstable";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "d659a361f6d5165462c10e1c1243f420175e066b";
    hash = "sha256-856O6H03me3IM39/+6n56KJIetL+v4on6+lJx5D2Pcw=";
  };

  vendorSha256 = "sha256-5kZ0voyicnqK/0yrMYW+gR1vVDyptW6I1HgyG4zleX8=";

  meta = with lib; {
    description = "CLI DNS lookup tool";
    homepage = "https://github.com/zmap/zdns";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
