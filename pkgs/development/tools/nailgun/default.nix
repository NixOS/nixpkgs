{ lib, stdenv, fetchMavenArtifact, fetchFromGitHub, jre, makeWrapper }:

let
  version = "1.0.0";
  nailgun-server = fetchMavenArtifact {
    groupId = "com.facebook";
    artifactId = "nailgun-server";
    inherit version;
    sha256 = "1mk8pv0g2xg9m0gsb96plbh6mc24xrlyrmnqac5mlbl4637l4q95";
  };
in
stdenv.mkDerivation {
  pname = "nailgun";
  inherit version;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "nailgun";
    rev = "nailgun-all-v${version}";
    sha256 = "1syyk4ss5vq1zf0ma00svn56lal53ffpikgqgzngzbwyksnfdlh6";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${jre}/bin/java $out/bin/ng-server \
      --add-flags '-classpath ${nailgun-server.jar}:$CLASSPATH com.facebook.nailgun.NGServer'
  '';

  meta = with lib; {
    description = "Client, protocol, and server for running Java programs from the command line without incurring the JVM startup overhead";
    homepage = "http://www.martiansoftware.com/nailgun/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
