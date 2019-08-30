{ lib, fetchFromGitHub, buildGoPackage, pigeon }:
buildGoPackage rec {
  pname = "verifpal";
  version = "0.2";

  goPackagePath = "github.com/SymbolicSoft/verifpal";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "SymbolicSoft";
    repo = pname;
    rev = version;
    sha256 = "08a0xvgg94k6vq91ylvgi97kpkjbw0rw172v2dzwl2rfpzkigk1r";
  };

  postPatch = ''
    sed -e 's|/bin/echo |echo |g' -i Makefile
  '';

  buildInputs = [ pigeon ];

  buildPhase = ''
    make -C go/src/$goPackagePath parser linux
  '';

  installPhase = ''
    mkdir -p $bin/bin
    cp go/src/$goPackagePath/build/bin/linux/verifpal $bin/bin/
  '';

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
    platforms = ["x86_64-linux"];
  };
}
