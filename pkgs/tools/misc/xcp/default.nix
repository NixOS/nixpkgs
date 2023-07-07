{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DrB7eVo7nFsp2jGVygbBvj7zOztJ8jDkLODRFfxXhjY=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-O16aY+s27LBMcbefz4ug5+EuGAAiNsD7D0nv5KPg+Us=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
