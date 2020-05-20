{ autoPatchelfHook
, buildPythonPackage
, coreutils
, fetchPypi
, jre
, lib
, maven
, protobuf
, pythonPackages
, stdenv
}:

buildPythonPackage rec {
  pname = "skein";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nb64p1hzshgi1kfc2jx1v9vn8b0wzs50460wfra3fsxh0ap66ab";
  };

  skeinRepo = stdenv.mkDerivation rec {
    name = "${pname}-${version}-maven-repo";

    inherit src;

    nativeBuildInputs = [ maven ] ++ lib.optional stdenv.isLinux autoPatchelfHook;

    buildPhase = "";

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

  } // lib.optionalAttrs stdenv.isLinux { dontAutoPatchelf = true; };

  # skein wants to compile a .jar file for Hadoop interaction. We build
  # it separately as otherwise mvn is called from setup.py and we have
  # no good way to inject the repository in there.
  skeinJar = stdenv.mkDerivation rec {
    name = "${pname}-${version}.jar";

    inherit src;

    nativeBuildInputs = [ maven ];

    buildPhase = ''
      mvn --offline -f java/pom.xml package -Dmaven.repo.local="${skeinRepo}" -Dskein.version=${version} -Dversion=${version}
    '';

    installPhase = ''
      # Making sure skein.jar exists skips the maven build in setup.py
      mv java/target/skein-*.jar $out
    '';
  };

  propagatedBuildInputs = with pythonPackages; [ cryptography grpcio grpcio-tools jupyter pytest pyyaml requests jre ];

  preBuild = ''
    # Making sure skein.jar exists skips the maven build in setup.py
    mkdir -p skein/java
    ln -s ${skeinJar} skein/java/skein.jar
  '';

  meta = with stdenv.lib; {
    homepage = "https://jcristharif.com/skein";
    description = "A tool and library for easily deploying applications on Apache YARN";
    license = licenses.bsd3;
  };

}
