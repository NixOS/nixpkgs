{ appleDerivation, cctools, zlib }:

appleDerivation {
  buildInputs = [ cctools zlib ];

  buildPhase = ''
    export CFLAGS=" -I$PWD/head -I$PWD/sys -I$PWD/libelf -I$PWD/libdwarf"

    pushd libelf
    for f in *.c; do
      if [ "$f" != "lintsup.c" ]; then # Apple doesn't use it, so I don't either
        cc -D_INT64_TYPE -D_LONGLONG_TYPE -D_ILP32 $CFLAGS -c $f
      fi
    done
    libtool -static -o libelf.a *.o
    popd

    pushd libdwarf
    ./configure CFLAGS="$CFLAGS -Icmplrs"
    make
    popd

    cp libelf/libelf.a     tools/ctfconvert
    cp libdwarf/libdwarf.a tools/ctfconvert

    pushd tools/ctfconvert
    for f in ../../darwin_shim.c *.c; do
      cc -DNDEBUG -DNS_BLOCK_ASSERTIONS $CFLAGS -c $f
    done

    export COMMON="alist.o ctf.o darwin_shim.o hash.o iidesc.o input.o list.o \
      memory.o output.o stack.o strtab.o symbol.o tdata.o traverse.o util.o"

    export CONVERT="ctfconvert.o dwarf.o merge.o st_bugs.o st_parse.o stabs.o"
    export MERGE="barrier.o ctfmerge.o dwarf.o fifo.o merge.o st_bugs.o st_parse.o stabs.o utils.o"
    export DUMP="dump.o fifo.o utils.o"

    clang -o ctfconvert $CONVERT $COMMON -L. -lz -lelf -ldwarf
    clang -o ctfmerge   $MERGE   $COMMON -L. -lz -lelf -ldwarf
    clang -o ctfdump    $DUMP    $COMMON -L. -lz -lelf
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tools/ctfconvert/ctfconvert $out/bin
    cp tools/ctfconvert/ctfmerge   $out/bin
    cp tools/ctfconvert/ctfdump    $out/bin
  '';
}
