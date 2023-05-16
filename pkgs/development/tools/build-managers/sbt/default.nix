{ lib
, stdenv
, fetchurl
, jre
, autoPatchelfHook
, zlib
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "sbt";
  version = "1.9.4";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${finalAttrs.version}/sbt-${finalAttrs.version}.tgz";
    hash = "sha256-aL0CJcKdo5ss+yW2dwqRn2nkdiG7JQESFSdC1/KauHA=";
=======
stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
    sha256 = "sha256-H2U0TaB029Zt/vqTwO/40xnXcuXK1H/L62rheLvfRoY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc # libstdc++.so.6
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -sT ../share/sbt/bin/sbt $out/bin/sbt
    ln -sT ../share/sbt/bin/sbtn-x86_64-${
      if (stdenv.isDarwin) then "apple-darwin" else "pc-linux"
    } $out/bin/sbtn

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.scala-sbt.org/";
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    description = "A build tool for Scala, Java and more";
<<<<<<< HEAD
    maintainers = with maintainers; [ nequissimus kashw2 ];
    platforms = platforms.unix;
  };
})
=======
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
