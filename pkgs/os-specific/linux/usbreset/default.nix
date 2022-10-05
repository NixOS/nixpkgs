{ stdenv, fetchFromGitHub, lib, ... }:
stdenv.mkDerivation rec {
  pname = "usbreset";
  version = "unstable-2018-09-21";

  src = fetchFromGitHub {
    owner = "jkulesza";
    repo = pname;
    rev = "7cad37246bdb116d92be05f458605b72cd8a70c7";
    sha256 = "sha256:04hihfs8nrf53zi6kbbzfwp2aiqjddjrrq5fic2v3s4q1kx7wq16";
  };

  buildPhase = ''
    cc usbreset.c -o usbreset
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp usbreset $out/bin/usbreset
    chmod +x $out/bin/usbreset
  '';

  meta = {
    description = "Linux USB Device Reset Application";
    homepage = "https://github.com/jkulesza/usbreset";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cheriimoya ];
  };
}
