{ lib
, stdenv
, makeWrapper
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "ps3iso-utils";
  version = "277db7de";

  src = fetchFromGitHub {
    owner = "bucanero";
    repo = "ps3iso-utils";
    rev = version;
    sha256 = "sha256-CVzJxbYJ2zbBGreqkRFNf3Nw2nj2vpK63DolCYzDFes=";
  };

  buildPhase = ''
    make -C extractps3iso
    make -C makeps3iso
    make -C patchps3iso
    make -C splitps3iso
  '';

  installPhase = ''
    mkdir -p $out/bin
    find -name "*ps3iso" -type f -exec install -Dm 755 \{} $out/bin \;
  '';


  nativeBuildInputs = [
    makeWrapper
  ];

  meta = {
    homepage = "https://github.com/bucanero/ps3iso-utils";
    description = "Windows, Linux, and macOS builds of Estwald's PS3ISO utilities";
    license = lib.licenses.gpl3;
    maintainers = [ "evanjs" ];
  };
}
