{
  lib,
  buildGoModule,
  fetchFromGitHub,
  llvmPackages,
  getconf,
}:

buildGoModule rec {
  pname = "gllvm";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "v${version}";
    sha256 = "sha256-CoreqnMRuPuv+Ci1uyF3HJCJFwK2jwB79okynv6AHTA=";
  };

  vendorHash = null;

  nativeCheckInputs =
    with llvmPackages;
    [
      clang
      llvm
    ]
    ++ lib.optionals stdenv.isDarwin [ getconf ];

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
