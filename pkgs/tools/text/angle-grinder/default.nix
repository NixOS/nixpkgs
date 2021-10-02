{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jG3jHFqFOrIT/e5oyLOEckw5C3LIs7amFAa4QDEI/EY=";
  };

  cargoSha256 = "sha256-Rkex+fnnacV+DCRpX3Zh9J3vGuG4QfFhFezHTs33peY=";

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
