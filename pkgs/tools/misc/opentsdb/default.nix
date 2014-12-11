{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
let
  thirdPartyDeps = {
    guava = {
      "guava-18.0.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/com/google/guava/guava/18.0/guava-18.0.jar;
        md5 = "947641f6bb535b1d942d1bc387c45290";
      };
    };
    gwt = {
      "gwt-dev-2.6.0.jar" = fetchurl {
        url = http://central.maven.org/maven2/com/google/gwt/gwt-dev/2.6.0/gwt-dev-2.6.0.jar;
        md5 = "23d8bf52709230c2c7e6dd817261f9ee";
      };
      "gwt-user-2.6.0.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/com/google/gwt/gwt-user/2.6.0/gwt-user-2.6.0.jar;
        md5 = "99226fc2764f2b8fd6db6e05d0847659";
      };
    };
    hamcrest = {
      "hamcrest-core-1.3.jar" = fetchurl {
         url = http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;
         md5 = "6393363b47ddcbba82321110c3e07519";
      };
    };
    hbase = {
      "asynchbase-1.6.0.jar" = fetchurl {
        url = http://central.maven.org/maven2/org/hbase/asynchbase/1.6.0/asynchbase-1.6.0.jar;
        md5 = "6738dd73fd48d30cbf5c78f62bc18852";
      };
    };
    jackson = {
      "jackson-annotations-2.4.3.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.4.3/jackson-annotations-2.4.3.jar;
        md5 = "31ef4fa866f9d24960a6807c9c299e98";
      };
      "jackson-core-2.4.3.jar" = fetchurl {
        url = http://central.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.4.3/jackson-core-2.4.3.jar;
        md5 = "750ef3d86f04fe0d6d14d6ae904a6d2d";
      };
      "jackson-databind-2.4.3.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.4.3/jackson-databind-2.4.3.jar;
        md5 = "4fcb9f74280eaa21de10191212c65b11";
      };
    };
    javassist = {
      "javassist-3.18.1-GA.jar" = fetchurl {
        url = http://central.maven.org/maven2/org/javassist/javassist/3.18.1-GA/javassist-3.18.1-GA.jar;
        md5 = "5bb83868c87334320562af7eded65cc2";
      };
    };
    junit = {
      "junit-4.11.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/junit/junit/4.11/junit-4.11.jar;
        md5 = "3c42be5ea7cbf3635716abbb429cb90d";
      };
    };
    logback = {
      "logback-classic-1.0.13.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/logback-classic-1.0.13.jar;
        md5 = "b4dc8eb42150aafd6d9fd3d211807621";
      };
      "logback-core-1.0.13.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/logback-core-1.0.13.jar;
        md5 = "3d5f8ce8dca36e493d39177b71958bd4";
      };
    };
    mockito = {
      "mockito-1.9.0.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/mockito-1.9.0.jar;
        md5 = "cab21b44958a173a5b1d55a6aff0ab54";
      };
      "mockito-core-1.9.5.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/mockito-core-1.9.5.jar;
        md5 = "98f3076e2a691d1ac291624e5a46b80b";
      };
    };
    netty = {
      "netty-3.9.4.Final.jar" = fetchurl {
        url = http://central.maven.org/maven2/io/netty/netty/3.9.4.Final/netty-3.9.4.Final.jar;
        md5 = "b3701ef46c7518d0d63705e2f092dbe5";
      };
    };
    objenesis = {
      "objenesis-1.3.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/org/objenesis/objenesis/1.3/objenesis-1.3.jar;
        md5 = "2d649907bd6203f2661f70d430a6ade8";
      };
    };
    powermock = {
      "powermock-mockito-release-full-1.5.4-full.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/org/powermock/powermock-mockito-release-full/1.5.4/powermock-mockito-release-full-1.5.4-full.jar;
        md5 = "5dee1dce6952bb7338d4d053157ae647";
      };
    };
    protobuf = {
      "protobuf-java-2.5.0.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar;
        md5 = "a44473b98947e2a54c54e0db1387d137";
      };
    };
    slf4j = {
      "log4j-over-slf4j-1.7.7.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/org/slf4j/log4j-over-slf4j/1.7.7/log4j-over-slf4j-1.7.7.jar;
        md5 = "93ab42a5216afd683c35988c6b6fc3d8";
      };
      "slf4j-api-1.7.7.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.7/slf4j-api-1.7.7.jar;
        md5 = "ca4280bf93d64367723ae5c8d42dd0b9";
      };
    };
    suasync = {
      "suasync-1.4.0.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/suasync-1.4.0.jar;
        md5 = "289ce3f3e6a9bb17857981eacf6d74b6";
      };
    };
    validation-api = {
      "validation-api-1.0.0.GA.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/javax/validation/validation-api/1.0.0.GA/validation-api-1.0.0.GA.jar;
        md5 = "40c1ee909493066397a6d4d9f8d375d8";
      };
      "validation-api-1.0.0.GA-sources.jar" = fetchurl {
        url = http://repo1.maven.org/maven2/javax/validation/validation-api/1.0.0.GA/validation-api-1.0.0.GA-sources.jar;
        md5 = "f816682933b59c5ffe32bdb4ab4bf628";
      };
    };
    zookeeper = {
      "zookeeper-3.3.6.jar" = fetchurl {
        url = https://opentsdb.googlecode.com/files/zookeeper-3.3.6.jar;
        md5 = "02786e11c19d1671640992f1bda4a858";
      };
    };
  };

in stdenv.mkDerivation rec {
  name = "opentsdb-2.1.0-rc1";

  src = fetchurl {
    url = https://github.com/OpenTSDB/opentsdb/archive/v2.1.0RC1.tar.gz;
    sha256 = "01li02j8kjanmas2gxkcz3gsn54nyfyvqdylxz3fqqjgg6y7hrm7";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python ];

  configurePhase = ''
    echo > build-aux/fetchdep.sh.in
    ./bootstrap
    mkdir build
    cd build
    ../configure --prefix=$out
    patchShebangs ../build-aux/
  '';

  buildPhase =
    concatStringsSep
      "\n"
      (mapAttrsToList
        (folder: jars:
          "mkdir -p third_party/${folder}\n" +
          (concatStringsSep
            "\n"
            (mapAttrsToList
              (jar: src:
                 "ln -s ${src} third_party/${folder}/${jar}")
              jars)))
        thirdPartyDeps);

  installPhase = ''
    make install
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with stdenv.lib; {
    description = "Time series database with millisecond precision";
    homepage = http://opentsdb.net;
    license = licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.ocharles ];
  };
}
