{ lib
, stdenv
, fetchurl
, jre
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.4.7";

  src = fetchurl {
    url =
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
    sha256 = "sha256-wqdZ/kCjwhoWtaiNAM1m869vByHk6mG2OULfuDotVP0=";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ zlib ];

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -sT ../share/sbt/bin/sbt $out/bin/sbt
    ln -sT ../share/sbt/bin/sbtn-x86_64-${
      if (stdenv.isDarwin) then "apple-darwin" else "pc-linux"
    } $out/bin/sbtn
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    ($out/bin/sbt --offline --version 2>&1 || true) | grep 'getting org.scala-sbt sbt ${version}  (this may take some time)'
  '';

  meta = with lib; {
    homepage = "https://www.scala-sbt.org/";
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
