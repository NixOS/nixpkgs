{ lib, fetchFromGitHub, rustPlatform, udev, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "g933-utils";
  version = "unstable-2019-08-04";

  src = fetchFromGitHub {
    owner = "ashkitten";
    repo = "g933-utils";
    rev = "b80cfd59fc41ae5d577c147311376dd7f7882493";
    sha256 = "06napzpk3nayzixb4l4fzdiwpgmcrsbc5j9m4qip1yn6dfkin3p0";
  };

  cargoSha256 = "00gzfbxr5qzb9w7xkqd9jgfagb4c7p657m21b467pygzvaabbb8d";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "An application to configure Logitech wireless G933/G533 headsets";
    homepage = "https://github.com/ashkitten/g933-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
    platforms = platforms.linux;
  };
}
