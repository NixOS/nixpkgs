{
  lib,
  stdenv,
  fetchurl,
  jre,
  autoPatchelfHook,
  zlib,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbt";
  version = "1.11.3";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${finalAttrs.version}/sbt-${finalAttrs.version}.tgz";
    hash = "sha256-PqUJFayLmJuLH8niTllKYNPBgdQwE/6WSxX+s4RIOzw=";
  };

  postPatch = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc # libstdc++.so.6
    zlib
  ];

  propagatedBuildInputs = [
    # for infocmp
    ncurses
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -sT ../share/sbt/bin/sbt $out/bin/sbt
    ln -sT ../share/sbt/bin/sbtn-${
      if (stdenv.hostPlatform.isDarwin) then
        "universal-apple-darwin"
      else if (stdenv.hostPlatform.isAarch64) then
        "aarch64-pc-linux"
      else
        "x86_64-pc-linux"
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
    description = "Build tool for Scala, Java and more";
    maintainers = with maintainers; [
      nequissimus
      kashw2
    ];
    platforms = platforms.unix;
  };
})
