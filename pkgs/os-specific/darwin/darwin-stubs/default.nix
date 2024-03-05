{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "darwin-stubs";
  version = "10.12";

  src = fetchurl {
    url = "https://github.com/NixOS/darwin-stubs/releases/download/v20201216/10.12.tar.gz";
    sha256 = "1fyd3xig7brkzlzp0ql7vyfj5sp8iy56kgp548mvicqdyw92adgm";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
