{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-KR5gjRJH392s7Ue0F26slj4sRosFAAAahf6up+yOQno=";
  };

  cargoHash = "sha256-eL7VFLRfRVF2seWgHLWGudsTt5u+JcnNrJiD7K47EPA=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
