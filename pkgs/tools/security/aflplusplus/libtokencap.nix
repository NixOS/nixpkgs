{
  lib,
  stdenv,
  aflplusplus,
}:

stdenv.mkDerivation {
  version = lib.getVersion aflplusplus;
  pname = "libtokencap";

  src = aflplusplus.src;
  postUnpack = "chmod -R +w ${aflplusplus.src.name}";
  sourceRoot = "${aflplusplus.src.name}/utils/libtokencap";

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/lib/afl
    mkdir -p $out/share/doc/afl
  '';
  postInstall = ''
    mkdir $out/bin
    cat > $out/bin/get-libtokencap-so <<END
    #!${stdenv.shell}
    echo $out/lib/afl/libtokencap.so
    END
    chmod +x $out/bin/get-libtokencap-so
  '';

  meta = with lib; {
    homepage = "https://github.com/AFLplusplus/AFLplusplus";
    description = "strcmp & memcmp token capture library";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
