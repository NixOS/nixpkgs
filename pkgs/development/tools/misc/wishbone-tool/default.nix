{ lib, fetchFromGitHub, rustPlatform, libusb-compat-0_1 }:

let
  version = "0.6.9";
  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "wishbone-utils";
    rev = "v${version}";
    sha256 = "0gq359ybxnqvcp93cn154bs9kwlai62gnm71yvl2nhzjdlcr3fhp";
  };
in
rustPlatform.buildRustPackage {
  pname = "wishbone-tool";
  inherit version;

  src = "${src}/wishbone-tool";

  # N.B. The cargo vendor consistency checker searches in "source" for lockfile
  cargoDepsHook = ''
    ln -s wishbone-tool source
  '';
  cargoSha256 = "0mh8w8vqa7rzdaq0q6cbg9ds6y8g5fhqxcskqazz2lk5yk4shaim";

  buildInputs = [ libusb-compat-0_1 ];

  meta = with lib; {
    description = "Manipulate a Wishbone device over some sort of bridge";
    homepage = "https://github.com/litex-hub/wishbone-utils";
    license = licenses.bsd2;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.linux;
  };
}
