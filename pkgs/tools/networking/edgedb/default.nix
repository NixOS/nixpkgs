{ stdenv
, lib
, runCommand
, patchelf
, fetchFromGitHub
, rustPlatform
, makeWrapper
, pkg-config
, curl
, Security
, CoreServices
, libiconv
, xz
, perl
, substituteAll
}:

rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "unstable-2022-06-27";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "3c65c8bf0a09988356ad477d0ae234182f809b0a";
    sha256 = "sha256-UqoRa5ZbPJEHo9wyyygrN1ssorgY3cLw/mMrCDXr4gw=";
  };

  cargoSha256 = "sha256-6HJkkem44+dat5bmVEM+7GSJFjCz1dYZeRIPEoEwNlI=";

  nativeBuildInputs = [ makeWrapper pkg-config perl ];

  buildInputs = [
    curl
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv xz ];

  checkFeatures = [ ];

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.ranfdev ];
  };
}
