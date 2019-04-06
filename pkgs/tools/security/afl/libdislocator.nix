{ stdenv, afl}:

stdenv.mkDerivation rec {
  version = (builtins.parseDrvName afl.name).version;
  name = "libdislocator-${version}";

  src = afl.src;
  sourceRoot = "${afl.name}/libdislocator";

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

  meta = with stdenv.lib; {
    homepage = "http://lcamtuf.coredump.cx/afl/";
    description = ''
      Drop-in replacement for the libc allocator which improves
      the odds of bumping into heap-related security bugs in
      several ways.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
