{ lib
, stdenv
, fetchurl
, jre
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
    sha256 = "sha256-H2U0TaB029Zt/vqTwO/40xnXcuXK1H/L62rheLvfRoY=";
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
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
