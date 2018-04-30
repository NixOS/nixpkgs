{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gllvm-${version}";
  version = "2018-04-28"; # ~= 1.0.2, but no release tags yet

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "gllvm";
    rev = "7755cdabb9bd2c5115059c13dce986e4e38f624e";
    sha256 = "0a7mzmshyl4m216cxnar0pzjq98n2678x0czqfxgfdga55xp5frl";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
