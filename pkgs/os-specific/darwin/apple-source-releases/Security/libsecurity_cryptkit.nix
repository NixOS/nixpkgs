{appleDerivation, xcbuild, libsecurity_cssm, libsecurity_asn1}:
appleDerivation {
  name = "libsecurity_cryptkit";
  buildInputs = [xcbuild libsecurity_cssm libsecurity_asn1];
  postUnpack = "sourceRoot=\${sourceRoot}/libsecurity_cryptkit";
  patchPhase = ''
    rm ../include/security_asn1
  '';
  NIX_CFLAGS_COMPILE = "-I../sec";
  installPhase = ''
    mkdir -p $out/lib $out/include/security_cryptkit
    cp Products/Release/CryptKit.a $out/lib/libCryptKit.a
    cp lib/*.h $out/include/security_cryptkit
  '';
}
