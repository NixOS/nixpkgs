{ lib
, stdenv
, fetchurl
, jre
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbt";
  version = "1.9.8";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${finalAttrs.version}/sbt-${finalAttrs.version}.tgz";
    hash = "sha256-qG//418Ga2XV4C67SiytHPu0GPgwv19z0n8wc+7K/c0=";
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
    ln -sT ../share/sbt/bin/sbtn-${
      if (stdenv.hostPlatform.isAarch64) then "aarch64" else "x86_64"
    }-${
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
    maintainers = with maintainers; [ nequissimus kashw2 ];
    platforms = platforms.unix;
  };
})
