import ./common.nix rec {
  pname = "opn2bankeditor";
  chip = "OPN2";
  version = "1.3";
  sha256 = "0niam6a6y57msbl0xj23g6l7gisv4a670q0k1zqfm34804532a32";
  extraPatches = [
    ./0001-opn2bankeditor-Look-for-system-installed-Rt-libs.patch
  ];
}
