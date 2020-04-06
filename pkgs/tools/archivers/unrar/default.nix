{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "unrar";
  version = "5.9.1";

  src = fetchurl {
    url = "https://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0071inswykarjbg4a80fz4n9xdinjfvxd9kmwz5gq0i1w2wd3c8f";
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

  meta = with stdenv.lib; {
    description = "Utility for RAR archives";
    homepage = https://www.rarlab.com/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
