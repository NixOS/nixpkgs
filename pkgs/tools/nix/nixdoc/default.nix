{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tazjin";
    repo  = "nixdoc";
    rev = "v${version}";
    sha256 = "14d4dq06jdqazxvv7fq5872zy0capxyb0fdkp8qg06gxl1iw201s";
  };

  patches = [
    # Support nested identifiers https://github.com/nix-community/nixdoc/pull/27
    (fetchpatch {
      url = "https://github.com/nix-community/nixdoc/pull/27/commits/ea542735bf675fe2ccd37edaffb9138d1a8c1b7e.patch";
      sha256 = "1fmz44jv2r9qsnjxvkkjfb0safy69l4x4vx1g5gisrp8nwdn94rj";
    })
  ];

  buildInputs =  lib.optionals stdenv.isDarwin [ darwin.Security ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "arenatree-0.1.1" = "sha256-b3VVbYnWsjSjFMxvkfpJt13u+VC6baOIWD4qm1Gco4Q=";
      "rnix-0.4.1" = "sha256-C1L/qXk6AimH7COrBlqpUA3giftaOYm/qNxs7rQgETA=";
    };
  };

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/tazjin/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.tazjin ];
    platforms   = platforms.unix;
  };
}
