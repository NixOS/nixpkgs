{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:
rustPlatform.buildRustPackage rec {
  pname = "manix";
  version = "0.7.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "lecoqjacob";
    rev = "${version}";
    hash = "sha256-kTQbeOIGG1HmbsXKfXw5yCZ49kGufbGiCkkIRMTwcsg=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [Security];
  cargoSha256 = "sha256-7SHUi1qH9Dr4Oi7A6gRmZqhAIr8RzLNU1l1x4WGtQYI=";

  meta = with lib; {
    license = [licenses.mpl20];
    platforms = platforms.unix;
    homepage = "https://github.com/lecoqjacob/manix";
    description = "A Fast Documentation Searcher for Nix";
    maintainers = [maintainers.lecoqjacob];
  };
}
