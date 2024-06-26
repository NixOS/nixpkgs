{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-pQhzyXLurFnBn9DkkXA54NsAX8wE4rQvaHXZLkLDwdw=";
  };

  cargoHash = "sha256-gfCH/jnJTUiqwzxUYuZuFWh9Wq8hp43z2gRdaDQ908g=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}
