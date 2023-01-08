{ lib, stdenv, stdenvNoCC, fetchMavenArtifact, fetchFromGitHub, jre, makeWrapper, symlinkJoin }:

let
  version = "1.0.0";
  nailgun-server = fetchMavenArtifact {
    groupId = "com.facebook";
    artifactId = "nailgun-server";
    inherit version;
    sha256 = "1mk8pv0g2xg9m0gsb96plbh6mc24xrlyrmnqac5mlbl4637l4q95";
  };

  commonMeta = {
    license = lib.licenses.asl20;
    homepage = "http://www.martiansoftware.com/nailgun/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };

  server = stdenvNoCC.mkDerivation {
    pname = "nailgun-server";
    inherit version;

    nativeBuildInputs = [ makeWrapper ];

    dontUnpack = true;
    installPhase = ''
      runHook preInstall

      makeWrapper ${jre}/bin/java $out/bin/ng-server \
        --add-flags '-classpath ${nailgun-server.jar}:$CLASSPATH com.facebook.nailgun.NGServer'

      runHook postInstall
    '';

    meta = commonMeta // {
      description = "Server for running Java programs from the command line without incurring the JVM startup overhead";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    };
  };

  client = stdenv.mkDerivation {
    pname = "nailgun-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "facebook";
      repo = "nailgun";
      rev = "nailgun-all-v${version}";
      sha256 = "1syyk4ss5vq1zf0ma00svn56lal53ffpikgqgzngzbwyksnfdlh6";
    };

    makeFlags = [ "PREFIX=$(out)" ];

    meta = commonMeta // {
      description = "Client for running Java programs from the command line without incurring the JVM startup overhead";
    };
  };
in
symlinkJoin rec {
  pname = "nailgun";
  inherit client server version;

  name = "${pname}-${version}";
  paths = [ client server ];

  meta = commonMeta // {
    description = "Client, protocol, and server for running Java programs from the command line without incurring the JVM startup overhead";
  };
}
