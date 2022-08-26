{ lib, fetchFromGitHub, upx }:

upx.overrideAttrs(oldAttrs: {
    pname = "upx";
    version = "unstable-2022-08-23";

    src = fetchFromGitHub {
      owner = "upx";
      repo  = "upx";
      rev   = "8ee39aaa34f41d4db0c28be966a7cb35e392eb79";
      hash  = "sha256-O3f+GSjMjSRF6DyB8nHgmU2bEJeqa48N6krgJD7pj6k=";
      fetchSubmodules = true;
    };
})
