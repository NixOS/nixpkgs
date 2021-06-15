{ lib
, stdenv
, fetchurl
, jre
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
    sha256 = "10kIQNy+3V1SD4uEZs/BJ4E6bTCRV3wjBN8gw9jr9VQ=";
  };

  postPatch = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ zlib ];

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
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
