{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "fundoc";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "csssr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qmsr4bhErpMzS71NhLep0EWimZb/S3aEhMbeBNa5y8E=";
  };

  cargoPatches = [
    # https://github.com/CSSSR/fundoc/pull/36
    (fetchpatch {
      name = "update-dependencies-for-rust-1.64.patch";
      url = "https://github.com/CSSSR/fundoc/commit/9e0c5f747088467b70bd385fcb8888950351143f.patch";
      hash = "sha256-JUTwMdxxt+2jst9DyqgkblZodBSYJzaDtjiLRQ8mJFU=";
    })
  ];

  cargoHash = "sha256-1gKxFznoGYGme0UicP73FQt8CnI9IeyHJxLgRcLffm0=";

  meta = with lib; {
    description = "Language agnostic documentation generator";
    homepage = "https://github.com/csssr/fundoc";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
