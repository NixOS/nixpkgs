{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "rowhammer-test";
  version = "unstable-2015-08-11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "rowhammer-test";
    rev = "c1d2bd9f629281402c10bb10e52bc1f1faf59cc4";
    sha256 = "1fbfcnm5gjish47wdvikcsgzlb5vnlfqlzzm6mwiw2j5qkq0914i";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-Wno-error=format";

  buildPhase = "sh -e make.sh";

  installPhase = ''
    mkdir -p $out/bin
    cp rowhammer_test double_sided_rowhammer $out/bin
  '';

  meta = with lib; {
    description = "Test DRAM for bit flips caused by the rowhammer problem";
    homepage = "https://github.com/google/rowhammer-test";
    license = licenses.asl20;
    maintainers = [ maintainers.viric ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
