{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "unrar";
  version = "6.1.5";

  src = fetchurl {
    url = "https://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "sha256-TlZxfYZ83/egAIt/Haaqeax6j5dM8TTUmowWtXe87Uo=";
  };

  postPatch = ''
    substituteInPlace makefile \
      --replace "CXX=" "#CXX=" \
      --replace "STRIP=" "#STRIP=" \
      --replace "AR=" "#AR="
  '';

  buildPhase = ''
    # `make {unrar,lib}` call `make clean` implicitly
    # move build results to another dir to avoid deleting them
    mkdir -p bin

    make unrar
    mv unrar bin

    make lib
    mv libunrar.so bin
  '';

  outputs = [ "out" "dev" ];

  installPhase = ''
    install -Dt "$out/bin" bin/unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar

    install -Dm755 bin/libunrar.so $out/lib/libunrar.so

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
