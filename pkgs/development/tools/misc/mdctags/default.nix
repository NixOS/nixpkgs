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

  cargoSha256 = "1kdbrcpvxiq91m5vq33vzjhsp4j3flzrpbj5hmxf0k3al1a7qk1g";

  meta = {
    description = "tags for markdown file";
    homepage = "https://github.com/wsdjeg/mdctags.rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
    mainProgram = "mdctags";
  };
}
