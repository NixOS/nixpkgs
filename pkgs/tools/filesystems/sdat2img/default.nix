{ stdenv, lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication {
  pname = "sdat2img";
  version = "unstable-2021-11-09";

  src = fetchFromGitHub {
    repo = "sdat2img";
    owner = "xpirt";
    rev = "b432c988a412c06ff24d196132e354712fc18929";
    sha256 = "sha256-NCbf9H0hoJgeDtP6cQY0H280BQqgKXv3ConZ87QixVY=";
  };

  format = "other";
  installPhase = ''
    install -D $src/sdat2img.py $out/bin/sdat2img
  '';

  meta = {
    description = "Convert sparse Android data image (.dat) into filesystem ext4 image (.img)";
    homepage = "https://github.com/xpirt/sdat2img";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xaverdh ];
    platforms = lib.platforms.unix;
  };
}
