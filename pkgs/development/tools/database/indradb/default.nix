{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, rustfmt
, protobuf
}:
let
  src = fetchFromGitHub {
    owner = "indradb";
    repo = "indradb";
    rev = "06134dde5bb53eb1d2aaa52afdaf9ff3bf1aa674";
    sha256 = "sha256-g4Jam7yxMc+piYQzgMvVsNTF+ce1U3thzYl/M9rKG4o=";
  };

  meta = with lib; {
    description = "Graph database written in rust";
    homepage = "https://github.com/indradb/indradb";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
in
{
  indradb-server = rustPlatform.buildRustPackage {
    pname = "indradb-server";
    version = "unstable-2021-01-05";
    inherit src meta;

    cargoHash = "sha256-3WtiW31AkyNX7HiT/zqfNo2VSKR7Q57/wCigST066Js=";

    buildAndTestSubdir = "server";

    PROTOC = "${protobuf}/bin/protoc";

    nativeBuildInputs = [ rustfmt rustPlatform.bindgenHook ];

    # test rely on libindradb and it can't be found
    # failure at https://github.com/indradb/indradb/blob/master/server/tests/plugins.rs#L63
    # `let _server = Server::start(&format!("../target/debug/libindradb_plugin_*.{}", LIBRARY_EXTENSION)).unwrap();`
    doCheck = false;
  };
  indradb-client = rustPlatform.buildRustPackage {
    pname = "indradb-client";
    version = "unstable-2021-01-05";
    inherit src meta;

    cargoHash = "sha256-pxan6W/CEsOxv8DbbytEBuIqxWn/C4qT4ze/RnvESOM=";

    PROTOC = "${protobuf}/bin/protoc";

    nativeBuildInputs = [ rustfmt rustPlatform.bindgenHook ];

    buildAndTestSubdir = "client";
  };
}
