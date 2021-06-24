{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vend";

  /*
  This package is used to generate vendor folders for
  packages that use the `runVend` option with `buildGoModule`.

  Do not update this package without checking that the vendorSha256
  hashes of packages using the `runVend` option are unchanged
  or updating their vendorSha256 hashes if necessary.
  */
  version = "1.0.2";
  # Disable the bot
  # nixpkgs-update: no auto update

  # Disable `mod tidy`, patch was refused upstream
  # https://github.com/nomad-software/vend/pull/9
  patches = [ ./remove_tidy.patch ];

  src = fetchFromGitHub {
    owner = "nomad-software";
    repo = "vend";
    rev = "v${version}";
    sha256 = "0h9rwwb56nzs46xsvl92af71i8b3wz3pf9ngi8v0i2bpk7p3p89d";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/nomad-software/vend";
    description = "A utility which vendors go code including c dependencies";
    maintainers = with maintainers; [ c00w mic92 zowoq ];
    license = licenses.mit;
  };
}
