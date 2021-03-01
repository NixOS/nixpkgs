{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "mdctags";
  version = "unstable-2020-06-11"; # v0.1.0 does not build with our rust version

  src = fetchFromGitHub {
    owner = "wsdjeg";
    repo = "mdctags.rs";
    rev = "0ed9736ea0c77e6ff5b560dda46f5ed0a983ed82";
    sha256 = "14gryhgh9czlkfk75ml0620c6v8r74i6h3ykkkmc7gx2z8h1jxrb";
  };

  cargoSha256 = "01ap2w755vbr01nfqc5185mr2w9y32g0d4ahc3lw2x3m8qv0bh6x";

  meta = {
    description = "tags for markdown file";
    homepage = "https://github.com/wsdjeg/mdctags.rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
  };
}
