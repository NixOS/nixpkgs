{ lib
, fetchpatch
, rustPlatform
, fetchFromGitHub
, testers
, difftastic
}:

let
  mimallocPatch = fetchpatch {
    name = "fix-build-on-older-macos-releases.patch";
    url = "https://github.com/microsoft/mimalloc/commit/40e0507a5959ee218f308d33aec212c3ebeef3bb.patch";
    sha256 = "sha256-DK0LqsVXXiEVQSQCxZ5jyZMg0UJJx9a/WxzCroYSHZc=";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    hash = "sha256-u03UL5QB0mdMTgRtxVe4pgLlCeLx1cG7czo7uBKQI84=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree_magic_mini-3.0.2" = "sha256-iIX/DeDbquObDPOx/pctVFN4R8GSkD9bPNkNgOLdUJs=";
    };
  };

  postPatch = ''
    patch -d $cargoDepsCopy/libmimalloc-sys-0.1.24/c_src/mimalloc \
      -p1 < ${mimallocPatch}
  '';

  passthru.tests.version = testers.testVersion { package = difftastic; };

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 figsoda ];
    mainProgram = "difft";
  };
}
