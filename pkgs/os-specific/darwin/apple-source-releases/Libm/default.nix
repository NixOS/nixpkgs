{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  patches = [
    # The source release version of math.h is missing some symbols that are actually present
    # in newer SDKs. Patch them into the header to avoid implicit function declaration errors
    # when compiling with newer versions of clang.
    ./missing-declarations.patch
  ];

  installPhase = ''
    mkdir -p $out/include

    cp Source/Intel/math.h $out/include
    cp Source/Intel/fenv.h $out/include
    cp Source/complex.h    $out/include
  '';
}
