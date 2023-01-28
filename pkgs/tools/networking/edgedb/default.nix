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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev =  "v${version}";
    sha256 = "sha256-U+fF0t+dj8wUfCviNu/zcoz3lhMXcQlDgz8B3gB+EJI=";
  };

  cargoSha256 = "sha256-Pm3PBg7sbFwLHaozfsbQbPd4gmcMUHxmGT4AsQRDX0g=";

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
