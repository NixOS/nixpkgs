{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "unrar";
  version = "5.9.2";

  src = fetchurl {
    url = "https://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "19nsxdvf9ll99hvgzq6f89ymxhwki224lygjdabrg8ghikqvmlvk";
  };

  postPatch = ''
    substituteInPlace makefile \
      --replace "CXX=" "#CXX=" \
      --replace "STRIP=" "#STRIP=" \
      --replace "AR=" "#AR="
  '';

  buildPhase = ''
    make unrar
    make clean
    make lib
  '';

  outputs = [ "out" "dev" ];

  installPhase = ''
    install -Dt "$out/bin" unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar

    install -Dm755 libunrar.so $out/lib/libunrar.so

    install -Dt $dev/include/unrar/ *.hpp
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
