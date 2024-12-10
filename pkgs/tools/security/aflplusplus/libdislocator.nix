{
  lib,
  stdenv,
  aflplusplus,
}:

stdenv.mkDerivation {
  version = lib.getVersion aflplusplus;
  pname = "libdislocator";

  src = aflplusplus.src;
  postUnpack = "chmod -R +w ${aflplusplus.src.name}";
  sourceRoot = "${aflplusplus.src.name}/utils/libdislocator";

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/lib/afl
  '';

  postInstall = ''
    mkdir $out/bin
    cat > $out/bin/get-libdislocator-so <<END
    #!${stdenv.shell}
    echo $out/lib/afl/libdislocator.so
    END
    chmod +x $out/bin/get-libdislocator-so
  '';

  meta = with lib; {
    homepage = "https://github.com/vanhauser-thc/AFLplusplus";
    description = ''
      Drop-in replacement for the libc allocator which improves
      the odds of bumping into heap-related security bugs in
      several ways.
    '';
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
