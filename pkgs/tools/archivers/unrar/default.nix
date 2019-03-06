{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unrar-${version}";
  version = "5.7.3";

  src = fetchurl {
    url = "https://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0i5442sh18v9s47k1j8q04m3ki98z012rw7ml7c5iwklhfvmds20";
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

  installPhase = ''
    install -Dt "$out/bin" unrar

    mkdir -p $out/share/doc/unrar
    cp acknow.txt license.txt \
        $out/share/doc/unrar

    install -Dm755 libunrar.so $out/lib/libunrar.so
    install -D dll.hpp $out/include/unrar/dll.hpp
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "Utility for RAR archives";
    homepage = http://www.rarlab.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
