{ lib
, stdenv
, autoconf
, automake
<<<<<<< HEAD
, curl
, fetchFromGitHub
, fetchMavenArtifact
, fetchpatch
=======
, bash
, curl
, fetchFromGitHub
, fetchMavenArtifact
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
, jdk8
, makeWrapper
, nettools
, python3
}:

let
  jdk = jdk8;
  jre = jdk8.jre;
  artifacts = {
    apache = [
      (fetchMavenArtifact {
        groupId = "org.apache.commons";
        artifactId = "commons-math3";
<<<<<<< HEAD
        version = "3.6.1";
        hash = "sha256-HlbXsFjSi2Wr0la4RY44hbZ0wdWI+kPNfRy7nH7yswg=";
=======
        version = "3.4.1";
        hash = "sha256-0QdbFKcQhwOLC/0Zjw992OSbWzUp2OLrqZ59nrhWXks=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];
    guava = [
      (fetchMavenArtifact {
        groupId = "com.google.guava";
        artifactId = "guava";
        version = "18.0";
        hash = "sha256-1mT7/APS5c6cqypE+wHx0L+d/r7MwaRzsfnqMfefb5k=";
      })
    ];
    gwt = [
      (fetchMavenArtifact {
        groupId = "com.google.gwt";
        artifactId = "gwt-dev";
<<<<<<< HEAD
        version = "2.6.1";
        hash = "sha256-iS8VpnMPuxE9L9hkTJVtW5Tqgw2TIYei47zRvkdoK0o=";
=======
        version = "2.6.0";
        hash = "sha256-4MLdI7q5fkftHTMoN7W3l5zsq1QB2R/8bF86vEqBI+A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "com.google.gwt";
        artifactId = "gwt-user";
<<<<<<< HEAD
        version = "2.6.1";
        hash = "sha256-3IlJ+b6C0Gmuh7aAFg9+ldgvZCdfJmTB8qcdC4HZC9g=";
=======
        version = "2.6.0";
        hash = "sha256-HR5/aopn605inHeENNHBAqKrjkvIl9wPDM+nOwOpiEg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "net.opentsdb";
        artifactId = "opentsdb-gwt-theme";
        version = "1.0.0";
        hash = "sha256-JJsjcRlQmIrwpOtMweH12e/Ut5NG8R50VPiOAMMGEdc=";
      })
    ];
    hamcrest = [
      (fetchMavenArtifact {
        url = "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar";
        groupId = "org.hamcrest";
        artifactId = "hamcrest-core";
        version = "1.3";
        hash = "sha256-Zv3vkelzk0jfeglqo4SlaF9Oh1WEzOiThqekclHE2Ok=";
      })
    ];
    hbase = [
      (fetchMavenArtifact {
        groupId = "org.hbase";
        artifactId = "asynchbase";
        version = "1.8.2";
        hash = "sha256-D7mKprHMW23dE0SzdNsagv3Hp2G5HUN7sKfs1nVzQF4=";
      })
    ];
    jackson = [
      (fetchMavenArtifact {
        groupId = "com.fasterxml.jackson.core";
        artifactId = "jackson-annotations";
<<<<<<< HEAD
        version = "2.14.1";
        hash = "sha256-0lW0uGP/jscUqPlvpVw0Yh1D27grgtP1dHZJakwJ4ec=";
=======
        version = "2.9.5";
        hash = "sha256-OKDkUASfZDVwrayZiIqjSA7C3jhXkKcJaQi/Q7/AhdY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "com.fasterxml.jackson.core";
        artifactId = "jackson-core";
<<<<<<< HEAD
        version = "2.14.1";
        hash = "sha256-ARQYfilrNMkxwb+eWoQVK2K/q30YL1Yj85gtwto15SY=";
=======
        version = "2.9.5";
        hash = "sha256-or66oyWtJUVbAhScZ+YFI2en1/wc533gAO7ShKUhTqw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "com.fasterxml.jackson.core";
        artifactId = "jackson-databind";
<<<<<<< HEAD
        version = "2.14.1";
        hash = "sha256-QjoMgG3ks/petKKGmDBeOjd3xzHhvPobLzo3YMe253M=";
=======
        version = "2.9.5";
        hash = "sha256-D7TgecEY51LMlMFa0i5ngrDfxdwJFF9IE/s52C5oYEc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];
    javacc = [
      (fetchMavenArtifact {
        groupId = "net.java.dev.javacc";
        artifactId = "javacc";
        version = "6.1.2";
        hash = "sha256-7Qxclglhz+tDE4LPAVKCewEVZ0fbN5LRv5PoHjLCBKs=";
      })
    ];
    javassist = [
      (fetchMavenArtifact {
        groupId = "org.javassist";
        artifactId = "javassist";
        version = "3.21.0-GA";
        hash = "sha256-eqWeAx+UGYSvB9rMbKhebcm9OkhemqJJTLwDTvoSJdA=";
      })
    ];
    jexl = [
      (fetchMavenArtifact {
        groupId = "commons-logging";
        artifactId = "commons-logging";
<<<<<<< HEAD
        version = "1.2";
        hash = "sha256-2t3qHqC+D1aXirMAa4rJKDSv7vvZt+TmMW/KV98PpjY=";
=======
        version = "1.1.1";
        hash = "sha256-zm+RPK0fDbOq1wGG1lxbx//Mmpnj/o4LE3MSgZ98Ni8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "org.apache.commons";
        artifactId = "commons-jexl";
        version = "2.1.1";
        hash = "sha256-A8mp+uXaeM5SwL8kRnzDc1W34jGW3/SDniwP8BigEwY=";
      })
    ];
    jgrapht = [
      (fetchMavenArtifact {
        groupId = "org.jgrapht";
        artifactId = "jgrapht-core";
        version = "0.9.1";
        hash = "sha256-5u8cEVaJ7aCBQrhtUkYg2mQ7bp8BNAUletB/QtxcaXg=";
      })
    ];
    junit = [
      (fetchMavenArtifact {
        groupId = "junit";
        artifactId = "junit";
        version = "4.11";
        hash = "sha256-kKjhYD7spI5+h586+8lWBxUyKYXzmidPb2BwtD+dBv4=";
      })
    ];
    kryo = [
      (fetchMavenArtifact {
        groupId = "org.ow2.asm";
        artifactId = "asm";
        version = "4.0";
        hash = "sha256-+y3ekCCke7AkxD2d4KlOc6vveTvwjwE1TMl8stLiqVc=";
      })
      (fetchMavenArtifact {
        groupId = "com.esotericsoftware.kryo";
        artifactId = "kryo";
        version = "2.21.1";
        hash = "sha256-adEG73euU3sZBp9WUQNLZBN6Y3UAZXTAxjsuvDuy7q4=";
      })
      (fetchMavenArtifact {
        groupId = "com.esotericsoftware.minlog";
        artifactId = "minlog";
        version = "1.2";
        hash = "sha256-pnjLGqj10D2QHJksdXQYQdmKm8PVXa0C6E1lMVxOYPI=";
      })
      (fetchMavenArtifact {
        groupId = "com.esotericsoftware.reflectasm";
        artifactId = "reflectasm";
        version = "1.07";
        classifier = "shaded";
        hash = "sha256-CKcOrbSydO2u/BGUwfdXBiGlGwqaoDaqFdzbe5J+fHY=";
      })
    ];
    logback = [
      (fetchMavenArtifact {
        groupId = "ch.qos.logback";
        artifactId = "logback-classic";
<<<<<<< HEAD
        version = "1.3.4";
        hash = "sha256-uGal2myLeOFVxn/M11YoYNC1/Hdric2WjC8/Ljf8OgI=";
=======
        version = "1.0.13";
        hash = "sha256-EsGTDKkWU0IqxJ/qM/zovhsfzS0iIM6jg8R5SXbHQY8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "ch.qos.logback";
        artifactId = "logback-core";
<<<<<<< HEAD
        version = "1.3.4";
        hash = "sha256-R0CgmLtEOnRFVN093wYsaCKHspQGZ1TikuE0bIv1zt0=";
=======
        version = "1.0.13";
        hash = "sha256-7NjyT5spQShOmPFU/zND5yDLMcj0e2dVSxRXRfWW87g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];
    mockito = [
      (fetchMavenArtifact {
        groupId = "org.mockito";
        artifactId = "mockito-core";
        version = "1.9.5";
        hash = "sha256-+XSDuglEufoTOqKWOHZN2+rbUew9vAIHTFj6LK7NB/o=";
      })
    ];
    netty = [
      (fetchMavenArtifact {
        groupId = "io.netty";
        artifactId = "netty";
        version = "3.10.6.Final";
        hash = "sha256-h2ilD749k6iNjmAA6l1o4w9Q3JFbN2TDxYcPcMT7O0k=";
      })
    ];
    objenesis = [
      (fetchMavenArtifact {
        groupId = "org.objenesis";
        artifactId = "objenesis";
        version = "1.3";
        hash = "sha256-3U7z0wkQY6T+xXjLsrvmwfkhwACRuimT3Nmv0l/5REo=";
      })
    ];
    powermock = [
      (fetchMavenArtifact {
        groupId = "org.powermock";
        artifactId = "powermock-mockito-release-full";
        version = "1.5.4";
        classifier = "full";
        hash = "sha256-GWXaFG/ZtPlc7uKrghQHNAPzEu2k5VGYCYTXIlbylb4=";
      })
    ];
    protobuf = [
      (fetchMavenArtifact {
        groupId = "com.google.protobuf";
        artifactId = "protobuf-java";
        version = "2.5.0";
        hash = "sha256-4MHGRXXABWAXJefGoCzr+eEoXoiPdWsqHXP/qNclzHQ=";
      })
    ];
    slf4j = [
      (fetchMavenArtifact {
        groupId = "org.slf4j";
        artifactId = "log4j-over-slf4j";
<<<<<<< HEAD
        version = "2.0.6";
        hash = "sha256-QHMpiJioL0KeHr2iNaMUc7G0jDR94ShnNbtnkiUm6uQ=";
=======
        version = "1.7.7";
        hash = "sha256-LjcWxCtsAm/jzd2pK7oaVZsTZjjcexj7qKQSxBiVecI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
      (fetchMavenArtifact {
        groupId = "org.slf4j";
        artifactId = "slf4j-api";
<<<<<<< HEAD
        version = "2.0.6";
        hash = "sha256-LyqS1BCyaBOdfWO3XtJeIZlc/kEAwZvyNXfP28gHe9o=";
=======
        version = "1.7.7";
        hash = "sha256-aZgMA4yhsTGSZWFZFhfZwl+r/Hspgor5FZfKhXDPNf4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      })
    ];
    suasync = [
      (fetchMavenArtifact {
        groupId = "com.stumbleupon";
        artifactId = "async";
        version = "1.4.0";
        hash = "sha256-FJ1HH68JOkjNtkShjLTJ8K4NO/A/qu88ap7J7SEndrM=";
      })
    ];
    validation-api = [
      (fetchMavenArtifact {
        groupId = "javax.validation";
        artifactId = "validation-api";
        version = "1.0.0.GA";
        hash = "sha256-5FnzE+vG2ySD+M6q05rwcIY2G0dPqS5A9ELo3l2Yldw=";
      })
      (fetchMavenArtifact {
        groupId = "javax.validation";
        artifactId = "validation-api";
        version = "1.0.0.GA";
        classifier = "sources";
        hash = "sha256-o5TVKpt/4rsU8HGNKzyDCP/o836RGVYBI5jVXJ+fm1Q=";
      })
    ];
    zookeeper = [
      (fetchMavenArtifact {
        groupId = "org.apache.zookeeper";
        artifactId = "zookeeper";
        version = "3.4.6";
        hash = "sha256-ijdaHvmMvA4fbp39DZbZFLdNN60AtL+Bvrd/qPNNM64=";
      })
    ];
  };
in stdenv.mkDerivation rec {
  pname = "opentsdb";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "OpenTSDB";
    repo = "opentsdb";
    rev = "refs/tags/v${version}";
    hash = "sha256-899m1H0UCLsI/bnSrNFnnny4MxSw3XBzf7rgDuEajDs=";
  };

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "bump-deps.0.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/2f4bbfba2f9a32f9295123e8b90adba022c11ece.patch";
      hash = "sha256-4LpR4O8mNiJZQ7PUmAzFdkZAaF8i9/ZM5NhQ+8AJgSw=";
    })
    (fetchpatch {
      name = "bump-deps.1.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/8c6a86ddbc367c7e4e2877973b70f77c105c6158.patch";
      hash = "sha256-LZHqDOhwO/Gfgu870hJ6/uxnmigv7RP8OFe2a7Ug5SM=";
    })
    (fetchpatch {
      name = "bump-deps.2.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/9b62442ba5c006376f57ef250fb7debe1047c3bf.patch";
      hash = "sha256-2VjI9EkirKj4h7xhUtWdnKxJG0Noz3Hk5njm3pYEU1g=";
    })
    (fetchpatch {
      name = "CVE-2023-25826.prerequisite.0.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/a82a4f85f0fc1af554a104f28cc495451b26b1f6.patch";
      hash = "sha256-GgoRZUGdKthK+ZwMpgSQQ4V2oHyqi8SwWGZT571gltQ=";
    })
    (fetchpatch {
      name = "CVE-2023-25826.prerequisite.1.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/22b27ea30a859a6dbdcd65fcdf61190d46e1b677.patch";
      hash = "sha256-pXo6U7d4iy2squAiFvV2iDAQcNDdrl0pIOQEXfkJ3a8=";
    })
    (fetchpatch {
      name = "CVE-2023-25826.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/07c4641471c6f5c2ab5aab615969e97211eb50d9.patch";
      hash = "sha256-88gIOhAhLCQC/UesIdYtjf0UgKNfnO0W2icyoMmiC3U=";
    })
    (fetchpatch {
      name = "CVE-2023-25827.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/fa88d3e4b5369f9fb73da384fab0b23e246309ba.patch";
      hash = "sha256-FJHUiEmGhBIHoyOwNZtUWA36ENbrqDkUT8HfccmMSe8=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
  ];

  buildInputs = [ curl jdk nettools python3 git ];

  preConfigure = ''
    chmod +x build-aux/fetchdep.sh.in
    patchShebangs ./build-aux/
    ./bootstrap
  '';

  preBuild = lib.concatStrings (lib.mapAttrsToList (dir: lib.concatMapStrings (artifact: ''
<<<<<<< HEAD
    cp ${artifact}/share/java/* third_party/${dir}
=======
    ln -s ${artifact}/share/java/* third_party/${dir}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '')) artifacts);

  postInstall = ''
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with lib; {
    description = "Time series database with millisecond precision";
    homepage = "http://opentsdb.net";
    license = licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # maven dependencies
    ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ ];
  };
}
