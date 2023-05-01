{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CAfbV5WKDMjKv2TSdnxpDEqdAwGWME/9PXLcU/TtM2U=";
  };

  cargoHash = "sha256-EDU+8sbCz4eyBwByHJwQc1Z0ftTZakGcYePbpl8sp08=";

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "agrind";
  };
}
