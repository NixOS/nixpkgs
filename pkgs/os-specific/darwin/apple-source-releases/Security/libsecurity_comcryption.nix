{appleDerivation, xcbuild}:
appleDerivation {
  name = "libsecurity_comcryption";
  buildInputs = [xcbuild];
  postUnpack = "sourceRoot=\${sourceRoot}/libsecurity_comcryption";
  installPhase = ''
    mkdir -p $out/lib $out/include/security_comcryption
    cp Products/Release/ComCryption.a $out/lib/libComCryption.a
    cp lib/*.h $out/include/security_comcryption
  '';
}
