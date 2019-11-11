{ lib
, fetchgit
, buildGoPackage
, pigeon
}:

buildGoPackage rec {
  pname = "verifpal";
  version = "0.7.5";

  goPackagePath = "github.com/SymbolicSoft/verifpal";
  goDeps = ./deps.nix;

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = version;
    sha256 = "0njgn6j5qg5kgid6ddv23axhw5gwjbayhdjkj4ya08mnxndr284m";
  };

  nativeBuildInputs = [ pigeon ];

  postPatch = ''
    sed -e 's|/bin/echo |echo |g' -i Makefile
  '';

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
    platforms = [ "x86_64-linux" ];
  };
}
