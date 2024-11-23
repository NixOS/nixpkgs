{
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  _60fps,
}:

callPackage ./generic.nix rec {
  pname = "sm64ex";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "20bb444562aa1dba79cf6adcb5da632ba580eec3";
    sha256 = "sha256-nw+F0upTetLqib5r5QxmcOauSJccpTydV3soXz9CHLQ=";
  };

  extraPatches = lib.optionals _60fps [
    (fetchpatch {
      name = "60fps_ex.patch";
      url = "file://${src}/enhancements/60fps_ex.patch";
      hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
    })
  ];

  extraMeta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
  };
}
