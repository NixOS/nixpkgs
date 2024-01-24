{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.2.45";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wSvVmKqucvg7Gs4H1o9i/d8f2I1g52Vq2Z8F7FwaOR0=";
  };

  cargoHash = "sha256-Gje7Sqe51IMzblydU0s1qXqfIIIQvt0EYMChVbK295s=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
