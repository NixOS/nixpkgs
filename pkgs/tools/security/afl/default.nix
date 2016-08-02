{ stdenv, fetchurl, bash, callPackage, makeWrapper
, clang, llvm, which, libcgroup }:

let
  afl-qemu = callPackage ./qemu.nix {};
  qemu-exe-name = if stdenv.system == "x86_64-linux" then "qemu-x86_64"
    else if stdenv.system == "i686-linux" then "qemu-i386"
    else throw "afl: no support for ${stdenv.system}!";
in
stdenv.mkDerivation rec {
  name    = "afl-${version}";
  version = "2.23b";

  src = fetchurl {
    url    = "http://lcamtuf.coredump.cx/afl/releases/${name}.tgz";
    sha256 = "152pqrc0py6jk1i3pwn2k928bsgax0d4yavpa3ca29bmrbzpnadh";
  };

  # Note: libcgroup isn't needed for building, just for the afl-cgroup
  # script.
  buildInputs  = [ makeWrapper clang llvm which ];

  buildPhase   = ''
    make PREFIX=$out
    cd llvm_mode
    make PREFIX=$out CC=${clang}/bin/clang CXX=${clang}/bin/clang++
    cd ..
  '';
  installPhase = ''
    # Do the normal installation
    make install PREFIX=$out

    # Install the custom QEMU emulator for binary blob fuzzing.
    cp ${afl-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace

    # Install the cgroups wrapper for asan-based fuzzing.
    cp experimental/asan_cgroups/limit_memory.sh $out/bin/afl-cgroup
    chmod +x $out/bin/afl-cgroup
    substituteInPlace $out/bin/afl-cgroup \
      --replace "cgcreate" "${libcgroup}/bin/cgcreate" \
      --replace "cgexec"   "${libcgroup}/bin/cgexec" \
      --replace "cgdelete" "${libcgroup}/bin/cgdelete"

    # Patch shebangs before wrapping
    patchShebangs $out/bin

    # Wrap afl-clang-fast(++) with a *different* AFL_PATH, because it
    # has totally different semantics in that case(?) - and also set a
    # proper AFL_CC and AFL_CXX so we don't pick up the wrong one out
    # of $PATH.
    for x in $out/bin/afl-clang-fast $out/bin/afl-clang-fast++; do
      wrapProgram $x \
        --prefix AFL_PATH : "$out/lib/afl" \
        --prefix AFL_CC   : "${clang}/bin/clang" \
        --prefix AFL_CXX  : "${clang}/bin/clang++"
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
