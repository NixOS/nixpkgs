{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mill";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "0x9mvcm5znyi7w6cpiasj2v6f63y7d8qdck7lx03p2k6i9aa2f77";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 "$src" "$out/bin/.mill-wrapped"
    # can't use wrapProgram because it sets --argv0
    makeWrapper "$out/bin/.mill-wrapped" "$out/bin/mill" \
      --prefix PATH : "${jre}/bin" \
      --set JAVA_HOME "${jre}"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.lihaoyi.com/mill";
    license = licenses.mit;
    description = "A build tool for Scala, Java and more";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with maintainers; [ scalavision ];
    platforms = lib.platforms.all;
  };
}
