{ lib
, fetchCrate
, rustPlatform
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.17.1";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    sha256 = "sha256-7RfJUYV3X9w0FALP3pbhmeIqrWLqlgr4oNvPnBc+RY8=";
  };

  cargoHash = "sha256-wmoXdukXWagW61jbFBODnIjlBrV6Q+wgvuFG/TqkvVk=";

  nativeCheckInputs = [
    capnproto
  ];

  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Rust";
    homepage = "https://github.com/capnproto/capnproto-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ mikroskeem ];
  };
}
