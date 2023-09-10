{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/WSxhdPekCNgeWf+ObIOblCUj3PyJvykGyCXrFmCXLA=";
  };

  vendorHash = "sha256-hdMBd0QI2uWktBV+rH73rCnnkIlw2zDT9OabUuWIGks=";

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
