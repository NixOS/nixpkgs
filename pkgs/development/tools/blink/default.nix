{ lib, stdenv, fetchFromGitHub
}:


stdenv.mkDerivation (rec {
  pname = "blink";
  version = "7d3fa0d1525dd0863dd57cfc4a6e60000795fab6";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "blink";
    rev = "${version}";
    hash = "sha256-LbvMh3FyV8dHIIQhYAY8U1na79ksmrf5vFmWdfk5cC8=";
  };

  doCheck = false;
  enableParallelBuilding = true;

  preCheck = ''
    rm third_party/cosmo/cosmo.mk
    # Removing that file because of the following problems:
    #  > make: *** [third_party/cosmo/cosmo.mk:6: third_party/cosmo/2/intrin_test.com.dbg.gz] Error 127
    #  > make: *** [third_party/cosmo/cosmo.mk:6: third_party/cosmo/2/lockscale_test.com.gz] Error 127
    #  > make: *** [third_party/cosmo/cosmo.mk:6: third_party/cosmo/2/lockscale_test.com.dbg.gz] Error 127
    #  > make: *** [third_party/cosmo/cosmo.mk:6: third_party/cosmo/2/palignr_test.com.gz] Error 127
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
