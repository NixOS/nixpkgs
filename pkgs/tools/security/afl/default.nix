{ stdenv, fetchurl, bash, callPackage, makeWrapper }:

let
  afl-qemu = callPackage ./qemu.nix {};
  qemu-exe-name = if stdenv.system == "x86_64-linux" then "qemu-x86_64"
    else if stdenv.system == "i686-linux" then "qemu-i386"
    else throw "afl: no support for ${stdenv.system}!";
in
stdenv.mkDerivation rec {
  name    = "afl-${version}";
  version = "1.57b";

  src = fetchurl {
    url    = "http://lcamtuf.coredump.cx/afl/releases/${name}.tgz";
    sha256 = "05dwh2kgz31702y339bvbs0b3ffadxgxk8cqqhs2i0ggx5bnl5p4";
  };

  buildInputs  = [ makeWrapper ];

  buildPhase   = "make PREFIX=$out";
  installPhase = ''
    # Do the normal installation
    make install PREFIX=$out

    # Install the custom QEMU emulator for binary blob fuzzing.
    cp ${afl-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace

    # Wrap every program with a custom $AFL_PATH; I believe there is a
    # bug in afl which causes it to fail to find `afl-qemu-trace`
    # relative to `afl-fuzz` or `afl-showmap`, so we instead set
    # $AFL_PATH as a workaround, which allows it to be found.
    for x in `ls $out/bin/afl-*`; do
      wrapProgram $x --prefix AFL_PATH : "$out/bin"
    done
  '';

  meta = {
    description = "Powerful fuzzer via genetic algorithms and instrumentation";
    longDescription = ''
      American fuzzy lop is a fuzzer that employs a novel type of
      compile-time instrumentation and genetic algorithms to
      automatically discover clean, interesting test cases that
      trigger new internal states in the targeted binary. This
      substantially improves the functional coverage for the fuzzed
      code. The compact synthesized corpora produced by the tool are
      also useful for seeding other, more labor or resource-intensive
      testing regimes down the road.
    '';
    homepage    = "http://lcamtuf.coredump.cx/afl/";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
