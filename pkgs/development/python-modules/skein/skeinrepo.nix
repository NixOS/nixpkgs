{ autoPatchelfHook, lib, maven, stdenv, src, version }:

stdenv.mkDerivation rec {
  pname = "skein-maven-repo";

  inherit version src;

  nativeBuildInputs = [ maven ] ++ lib.optional stdenv.isLinux autoPatchelfHook;

  installPhase = ''
    mkdir -p $out

    archs="${
      if stdenv.isLinux
      then "linux-x86_32 linux-x86_64"
      else "osx-x86_64"
    }"

    for arch in $archs
    do
      mvn -Dmaven.repo.local=$out dependency:get -Dartifact=com.google.protobuf:protoc:3.0.0:exe:$arch
      mvn -Dmaven.repo.local=$out dependency:get -Dartifact=io.grpc:protoc-gen-grpc-java:1.16.0:exe:$arch
    done

    if ${ lib.boolToString stdenv.isLinux }
    then
      autoPatchelf $out
    fi

    # We have to use maven package here as dependency:go-offline doesn't
    # fetch every required jar.
    mvn -f java/pom.xml -Dmaven.repo.local=$out package

    rm $(find $out -name _remote.repositories)
    rm $(find $out -name resolver-status.properties)
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = if stdenv.isLinux
    then "12f0q3444qw6y4f6qsa9540a0fz4cgi844zzi8z1phqn3k4dnl6v"
    else "0bjbwiv17cary1isxca0m2hsvgs1i5fh18z247h1hky73lnhbrz8";

} // lib.optionalAttrs stdenv.isLinux { dontAutoPatchelf = true; }
