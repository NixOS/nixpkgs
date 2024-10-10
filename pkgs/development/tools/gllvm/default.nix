{ lib, buildGoModule, fetchFromGitHub, llvmPackages, getconf }:

buildGoModule {
  pname = "gllvm";
  version = "1.3.1-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "154531bdd9c05cd9d01742bc1b35bdf200a487d3";
    sha256 = "sha256-dxrtJFqEEDKx33+sOm+R7huBwbovlKzL4qFXoco8A4s=";
  };

  vendorHash = null;

  nativeCheckInputs = with llvmPackages; [
    clang
    llvm
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ getconf ];

  meta = with lib; {
    homepage = "https://github.com/SRI-CSL/gllvm";
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
