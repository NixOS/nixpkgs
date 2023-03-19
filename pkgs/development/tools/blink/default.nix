{ lib, stdenv, fetchFromGitHub
}:


stdenv.mkDerivation (rec {
  pname = "blink";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "blink";
    rev = "${version}";
    hash = "sha256-GQ1uOZr75CXLQ6aUX4oohJhwsYy41StaZiQRNrD/FXQ=";
  };

  doCheck = true;
  enableParallelBuilding = true;

  checkPhase = ''
          runHook preCheck
          # The library author suggested this test as a fast one but very thorough.
          # Right now they depend on downloading binaries and that is why it is commented out.
          #make o//third_party/cosmo/2/intrin_test.com.ok
          runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install o/blink/blink $out/bin/blink
    install o/blink/blinkenlights $out/bin/blinkenlights
    runHook postInstall
  '';

  meta = {
    description = "tiniest x86-64-linux emulator";

    longDescription = ''
    blink is a virtual machine that runs x86-64-linux programs on different operating systems and hardware architectures. It's designed to do the same thing as the qemu-x86_64 command, except that

    blink is 190kb in size, whereas the qemu-x86_64 executable is 4mb

    blink will run your Linux binaries on any POSIX platform, whereas qemu-x86_64 only supports Linux

    blink goes 2x faster than qemu-x86_64 on some benchmarks, such as SSE integer / floating point math. Blink is also faster at running ephemeral programs such as compilers
    '';

    license = lib.licenses.isc;

    homepage = "https://github.com/jart/blink";

    maintainers = [ ];
  };
} // lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
  # This may be moved above during a stdenv rebuild.
  preConfigure = ''
    configureFlagsArray+=("CC=$CC")
  '';
})
