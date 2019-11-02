{ lib, fetchFromGitHub, rustPlatform, libusb }:
let
  version = "0.2.8";
  src = fetchFromGitHub {
    owner = "xobs";
    repo = "wishbone-utils";
    rev = "v${version}";
    sha256 = "0v6s5yl0y6bd2snf12x6c77rwvqkg6ybi1sm4wr7qdgbwq563nxp";
  };
in
rustPlatform.buildRustPackage {
  pname = "wishbone-tool";
  inherit version;
  src = "${src}/wishbone-tool";
  cargoSha256 = "0pj8kf6s1c666p4kc6q1hlvaqm0lm9aqnsx5r034g1y8sxnnyri2";
  buildInputs = [ libusb ];

  meta = with lib; {
    description = "Manipulate a Wishbone device over some sort of bridge";
    homepage = "https://github.com/xobs/wishbone-utils#wishbone-tool";
    license = licenses.bsd2;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.linux;
  };
}
