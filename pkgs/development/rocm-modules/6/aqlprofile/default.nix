{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
  fetchurl,
  callPackage,
  dpkg,
  rocm-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aqlprofile";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aqlprofile";
    # TODO: AMD haven't tagged anything in this repo, once that's fixed we can point
    # this at a tag and set up update script
    rev = "b20803e95dc3e9a3ffcef1f1500c4d8dd0fa3ab2";
    hash = "sha256-kaXbojl8T71nTLWJEX+g9EikwJiM1n4kXg3NFQ+Tzro=";
  };

  nativeBuildInputs = [
    cmake
    clr
  ];

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/aqlprofile/";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
