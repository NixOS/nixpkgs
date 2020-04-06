{ lib, fetchFromGitHub, rustPlatform, libusb }:

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
  cargoSha256 = "0d5kcwy0cgxqfxf2xysw65ng84q4knhp4fgvh6dwqhf0nsca9gvs";

  buildInputs = [ libusb ];

  meta = with lib; {
    description = "Manipulate a Wishbone device over some sort of bridge";
    homepage = "https://github.com/litex-hub/wishbone-utils";
    license = licenses.bsd2;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.linux;
  };
}
