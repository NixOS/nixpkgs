{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "2.2.0";
    hash = "sha256-x7ESuXoF5dYnJZpgDyYliVixCG4w/VX/Vhm3VqxsiEI=";
  };

  cargoPatches = [
    # https://github.com/badboy/mdbook-open-on-gh/pull/7
    (fetchpatch {
      name = "update-mdbook-for-rust-1.64.patch";
      url = "https://github.com/badboy/mdbook-open-on-gh/commit/bd20601bfcec144c9302b1ba1a1aff4b95b334d9.patch";
      hash = "sha256-3Df9Q3sqCpZzqCN9fi+wdeWjLUW4XdywIS3QUjsDE9g=";
    })
  ];

  cargoHash = "sha256-N0RwengTWk4luPIecIxzbFReGi+PtE77FJalPq1CdbA=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
