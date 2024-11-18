{
  lib,
  stdenv,
  AppKit,
  Security,
  fetchFromGitLab,
  rustPlatform,
  protobuf,
  capnproto,
  cmake,
  testers,
  veilid,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/RdPq2rHs+lfB3odwO7yRGFi3j0INdJvbWccTsGO54g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-l+WBdj4rkmFYPm6xBfu4XbqBWOzGCUqRpTOunR6Mm7E=";

  nativeBuildInputs = [
    capnproto
    cmake
    protobuf
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    Security
  ];

  cargoBuildFlags = [
    "--workspace"
  ];

  RUSTFLAGS = "--cfg tokio_unstable";

  doCheck = false;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      veilid-version = testers.testVersion {
        package = veilid;
      };
    };
  };

  meta = with lib; {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      bbigras
      qbit
    ];
  };
}
