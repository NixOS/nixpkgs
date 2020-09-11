{ stdenv, aflplusplus}:

stdenv.mkDerivation {
  version = stdenv.lib.getVersion aflplusplus;
  pname = "libdislocator";

  src = aflplusplus.src;
  postUnpack = "chmod -R +w ${aflplusplus.src.name}";
  sourceRoot = "${aflplusplus.src.name}/libdislocator";

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/lib/afl
    # issue is fixed upstream: https://github.com/AFLplusplus/AFLplusplus/commit/2a60ceb6944a7ca273057ddf64dcf837bf7f9521
    sed -i 's/README\.dislocator\.md/README\.md/g' Makefile
  '';
  postInstall = ''
    mkdir $out/bin
    cat > $out/bin/get-libdislocator-so <<END
    #!${stdenv.shell}
    echo $out/lib/afl/libdislocator.so
    END
    chmod +x $out/bin/get-libdislocator-so
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/vanhauser-thc/AFLplusplus";
    description = ''
      Drop-in replacement for the libc allocator which improves
      the odds of bumping into heap-related security bugs in
      several ways.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
