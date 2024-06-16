{ lib
, fetchpatch
, rustPlatform
, fetchFromGitHub
, testers
, difftastic
}:

let
  mimallocPatch = fetchpatch {
    # fixes compilation error on x86_64-darwin
    # remove after update to libmimalloc-sys >= 0.1.29
    # (fixed in mimalloc >= 1.7.6 which is included with libmimalloc-sys >= 0.1.29)
    url = "https://github.com/microsoft/mimalloc/commit/40e0507a5959ee218f308d33aec212c3ebeef3bb.patch";
    hash = "sha256-DK0LqsVXXiEVQSQCxZ5jyZMg0UJJx9a/WxzCroYSHZc=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    hash = "sha256-PTc8/NhWsLcKJj+9ebV/YaWEmyOWKJCYUjmVbr4z2SY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  # skip flaky tests
  checkFlags = [
    "--skip=options::tests::test_detect_display_width"
  ];

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
    maintainers = with maintainers; [ ethancedwards8 figsoda matthiasbeyer ];
    mainProgram = "difft";
  };
}
