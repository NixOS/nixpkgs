{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gn6qTfQjHuQUcfaZN48qCI7u8E7PtJAZlyrPqyjop5U=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-3vz92fHjLUMWVBpq71hxqqU0WiHdLbOst9vr8zbo6/U=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
