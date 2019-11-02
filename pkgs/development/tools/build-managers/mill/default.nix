{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mill";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "1y5044m0qlwa1wlg7xkhg76agmfn7bgcf040wf56fvxhf0w78zjw";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 "$src" "$out/bin/.mill-wrapped"
    # can't use wrapProgram because it sets --argv0
    makeWrapper "$out/bin/.mill-wrapped" "$out/bin/mill" --set JAVA_HOME "${jre}"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://www.lihaoyi.com/mill;
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
    platforms = stdenv.lib.platforms.all;
  };
}
