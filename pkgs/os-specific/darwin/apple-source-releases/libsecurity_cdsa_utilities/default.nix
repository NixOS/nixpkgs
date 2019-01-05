{ CommonCrypto, appleDerivation, libsecurity_codesigning, libsecurity_utilities, m4 }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    m4
  ];
  patchPhase = ''
    patch -p1 < ${./handletemplates.patch}
    unpackFile ${libsecurity_codesigning.src}
    mv libsecurity_codesigning*/lib security_codesigning
  '';
  NIX_CFLAGS_COMPILE = "-I${CommonCrypto}/include/CommonCrypto";
}
