{ lib, stdenv, callPackage, buildPackages, zip, perl, fetchFromGitHub, makeWrapper, writeText, fetchurl, ncurses, coreutils, bash, jdk, gnused, disableRemoteLogging ? true }:

let
  artifact = callPackage ./fetchArtifact.nix {};

  # Beware that this requires both versions to have the same tasty format version.
  # For example, 2.13.4 and 3.0.0-M1 do, while 2.13.4 and 3.0.0-M{2,3} don't.
  scalaVersion      = "3.0.0-M3";
  crossScalaVersion = "2.13.5-bin-aab85b1";

/*
produced with

```bash
export scalaVersion="3.0.0-M3"
export crossScalaVersion="2.13.5-bin-aab85b1"
export DEPS="org.scala-lang:scala3-compiler_$scalaVersion:$scalaVersion \
             org.scala-lang:scala-reflect:$crossScalaVersion \
             org.scala-lang.modules::scala-xml:1.2.0 \
             org.apache.sshd:sshd-core:1.2.+ \
             org.slf4j:slf4j-nop:1.7.+ \
             org.bouncycastle:bcprov-jdk15on:1.+ \
             io.get-coursier:interface:0.0.21 \
             org.javassist:javassist:3.21.0-GA \
             com.github.javaparser:javaparser-core:3.2.+ \
             org.jline:jline-terminal-jna:3.15.+ \
             org.jline:jline-reader:3.15.+ \
             ch.epfl.scala:bsp4j:2.0.0-M6 \
             org.scalameta::trees:4.3.20 \
             com.lihaoyi:fansi_$scalaVersion:0.+ \
             com.lihaoyi:pprint_$scalaVersion:0.+ \
             com.lihaoyi::os-lib:0.+ \
             com.lihaoyi::mainargs:0.+ \
             com.lihaoyi::upickle:1.+ \
             com.lihaoyi::sourcecode:0.+ \
             org.scala-lang.modules::scala-collection-compat:2.4.1 \
            "

mktable() {
  perl -pe 's,(\S+)\s+\S+/https/(\S+),"    (artifact { sha1 = \"$1\"; url = \"".("https://$2" =~ s|https://repo1.maven.org/maven2|mirror://maven|r)."\"; })",e'
}

sha1sum $(coursier fetch --repository scala-integration --scala-version $crossScalaVersion $DEPS                                                      | sort) | mktable
sha1sum $(coursier fetch --repository scala-integration                                    org.scala-lang:scala3-compiler_$scalaVersion:$scalaVersion | sort) | mktable
sha1sum $(coursier fetch --repository scala-integration                                    org.scala-lang:scala-compiler:$crossScalaVersion           | sort) | mktable
```
*/
  deps = [
    (artifact { sha1 = "ec687266052360e19106280ed861a17d52d40ff4"; url = "mirror://maven/ch/epfl/scala/bsp4j/2.0.0-M6/bsp4j-2.0.0-M6.jar"; })
    (artifact { sha1 = "83a23e10b1d35323ed8a768d48d5bfc2d2201cc5"; url = "mirror://maven/com/github/javaparser/javaparser-core/3.2.12/javaparser-core-3.2.12.jar"; })
    (artifact { sha1 = "3edcfe49d2c6053a70a2a47e4e1c2f94998a49cf"; url = "mirror://maven/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar"; })
    (artifact { sha1 = "3a3d111be1be1b745edfa7d91678a12d7ed38709"; url = "mirror://maven/com/google/guava/guava/21.0/guava-21.0.jar"; })
    (artifact { sha1 = "7ec0925cc3aef0335bbc7d57edfd42b0f86f8267"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.11.4/protobuf-java-3.11.4.jar"; })
    (artifact { sha1 = "a6dd7d850411c01650440be0c16f04c6bb1a488f"; url = "mirror://maven/com/lihaoyi/fansi_3.0.0-M3/0.2.10/fansi_3.0.0-M3-0.2.10.jar"; })
    (artifact { sha1 = "0a038a70bc90bf33dd0a9fa129dbc5eaa91509a2"; url = "mirror://maven/com/lihaoyi/fastparse_2.13/2.3.0/fastparse_2.13-2.3.0.jar"; })
    (artifact { sha1 = "8831c3af946628d4136e65d559146450a9b64c3d"; url = "mirror://maven/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5.jar"; })
    (artifact { sha1 = "ff3f950a7ed274d5c59f89ebb0e16ce1404db269"; url = "mirror://maven/com/lihaoyi/mainargs_2.13/0.2.1/mainargs_2.13-0.2.1.jar"; })
    (artifact { sha1 = "d414f8a6645f17f2885f74ba7ccba968a1518aae"; url = "mirror://maven/com/lihaoyi/os-lib_2.13/0.7.2/os-lib_2.13-0.7.2.jar"; })
    (artifact { sha1 = "1dbaebf0940e0a0cc02b52a732d077c8b1b5cf81"; url = "mirror://maven/com/lihaoyi/pprint_3.0.0-M3/0.6.1/pprint_3.0.0-M3-0.6.1.jar"; })
    (artifact { sha1 = "13eee684403828339270771c1b7dccdf4a2a9a60"; url = "mirror://maven/com/lihaoyi/sourcecode_2.13/0.2.1/sourcecode_2.13-0.2.1.jar"; })
    (artifact { sha1 = "020af5a8d03905ef07e5962bd794bbcff7dff5f6"; url = "mirror://maven/com/lihaoyi/sourcecode_3.0.0-M3/0.2.3/sourcecode_3.0.0-M3-0.2.3.jar"; })
    (artifact { sha1 = "0be176c15031bcbc6a310761cf61f108cbf89b67"; url = "mirror://maven/com/lihaoyi/ujson_2.13/1.2.3/ujson_2.13-1.2.3.jar"; })
    (artifact { sha1 = "0952720de0477287ca9430d120a0dcf660919ce4"; url = "mirror://maven/com/lihaoyi/upack_2.13/1.2.3/upack_2.13-1.2.3.jar"; })
    (artifact { sha1 = "c69ed10193bdb8926f7c890c33a7c9de84b140d7"; url = "mirror://maven/com/lihaoyi/upickle_2.13/1.2.3/upickle_2.13-1.2.3.jar"; })
    (artifact { sha1 = "ebfe8a71294000c9425d6023d14d881fa5686976"; url = "mirror://maven/com/lihaoyi/upickle-core_2.13/1.2.3/upickle-core_2.13-1.2.3.jar"; })
    (artifact { sha1 = "1c827a2d0141ff16c0310f02cc487f5f749d0dd1"; url = "mirror://maven/com/lihaoyi/upickle-implicits_2.13/1.2.3/upickle-implicits_2.13-1.2.3.jar"; })
    (artifact { sha1 = "849059166184a69dae78cdacfe4fdcefd68be8a9"; url = "mirror://maven/com/thesamet/scalapb/lenses_2.13/0.10.3/lenses_2.13-0.10.3.jar"; })
    (artifact { sha1 = "eec4be9930db513b43ac57a5d777036320faff70"; url = "mirror://maven/com/thesamet/scalapb/scalapb-runtime_2.13/0.10.3/scalapb-runtime_2.13-0.10.3.jar"; })
    (artifact { sha1 = "d90260e94686feed9c6ed245dd788b008193a78d"; url = "mirror://maven/io/get-coursier/interface/0.0.21/interface-0.0.21.jar"; })
    (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
    (artifact { sha1 = "4bc24a8228ba83dac832680366cf219da71dae8e"; url = "mirror://maven/org/apache/sshd/sshd-core/1.2.0/sshd-core-1.2.0.jar"; })
    (artifact { sha1 = "46a080368d38b428d237a59458f9bc915222894d"; url = "mirror://maven/org/bouncycastle/bcprov-jdk15on/1.68/bcprov-jdk15on-1.68.jar"; })
    (artifact { sha1 = "a9bc24a06267c6495439a4d998fcd49899399384"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.generator/0.8.1/org.eclipse.lsp4j.generator-0.8.1.jar"; })
    (artifact { sha1 = "4535bd0485fc3e6867b7d5ce0c74e7e7274a3ca4"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.8.1/org.eclipse.lsp4j.jsonrpc-0.8.1.jar"; })
    (artifact { sha1 = "c33ea2bd646e28de06df4695142a237c1237ccbc"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib/2.18.0/org.eclipse.xtend.lib-2.18.0.jar"; })
    (artifact { sha1 = "ad3ec3339240d8cc24a4b8f3549b559ac3bc7cdd"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.18.0/org.eclipse.xtend.lib.macro-2.18.0.jar"; })
    (artifact { sha1 = "ba7afe66b8fc19cce0c2da203c56291da74d410e"; url = "mirror://maven/org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.18.0/org.eclipse.xtext.xbase.lib-2.18.0.jar"; })
    (artifact { sha1 = "598244f595db5c5fb713731eddbb1c91a58d959b"; url = "mirror://maven/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar"; })
    (artifact { sha1 = "d4f88b2c96055e1369db7ef62c622c4697873c3a"; url = "mirror://maven/org/jline/jline-reader/3.15.0/jline-reader-3.15.0.jar"; })
    (artifact { sha1 = "139202af0195c369a2848fb5a36a3e1ea59270d8"; url = "mirror://maven/org/jline/jline-terminal/3.15.0/jline-terminal-3.15.0.jar"; })
    (artifact { sha1 = "9a6ba57d3910e25e8bca4aefc90c5671abd15b2e"; url = "mirror://maven/org/jline/jline-terminal-jna/3.15.0/jline-terminal-jna-3.15.0.jar"; })
    (artifact { sha1 = "233fb30e6fdc6ecb033ed948bdd3556077d08872"; url = "mirror://maven/org/scala-lang/modules/scala-asm/7.3.1-scala-1/scala-asm-7.3.1-scala-1.jar"; })
    (artifact { sha1 = "32c1c69e2e5d3b26ab83c70f82ae30fa9a2b406b"; url = "mirror://maven/org/scala-lang/modules/scala-collection-compat_2.13/2.4.1/scala-collection-compat_2.13-2.4.1.jar"; })
    (artifact { sha1 = "f6abd60d28c189f05183b26c5363713d1d126b83"; url = "mirror://maven/org/scala-lang/modules/scala-xml_2.13/1.2.0/scala-xml_2.13-1.2.0.jar"; })
    (artifact { sha1 = "048870f10035c734370cccb224c218d2e60ca828"; url = "mirror://maven/org/scala-lang/scala3-compiler_3.0.0-M3/3.0.0-M3/scala3-compiler_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "0cf4e8d1521b416a803ae98d444a63e80ab63dc2"; url = "mirror://maven/org/scala-lang/scala3-interfaces/3.0.0-M3/scala3-interfaces-3.0.0-M3.jar"; })
    (artifact { sha1 = "222a9b39778925d19ae16192198743f48d5a4997"; url = "mirror://maven/org/scala-lang/scala3-library_3.0.0-M3/3.0.0-M3/scala3-library_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "db159b7290b89203e6c7a6334f3b94f837426f2b"; url = "mirror://maven/org/scala-lang/tasty-core_3.0.0-M3/3.0.0-M3/tasty-core_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "a3ac866168292cc87ecb1d1a1aa3a12a66d8aff3"; url = "mirror://maven/org/scalameta/common_2.13/4.3.20/common_2.13-4.3.20.jar"; })
    (artifact { sha1 = "e20637428b7995a4cb6458b98d7f2d2f6b29b091"; url = "mirror://maven/org/scalameta/fastparse_2.13/1.0.1/fastparse_2.13-1.0.1.jar"; })
    (artifact { sha1 = "5b5b9cf2d2b0445ba99cc51cf724925966ced13d"; url = "mirror://maven/org/scalameta/fastparse-utils_2.13/1.0.1/fastparse-utils_2.13-1.0.1.jar"; })
    (artifact { sha1 = "ab7691342252c0fe3ae1220de09ab8347381f587"; url = "mirror://maven/org/scalameta/trees_2.13/4.3.20/trees_2.13-4.3.20.jar"; })
    (artifact { sha1 = "1f7379ff56b1795b523838cd06ff24272104c380"; url = "mirror://maven/org/scala-sbt/compiler-interface/1.3.5/compiler-interface-1.3.5.jar"; })
    (artifact { sha1 = "edc7556e112da142bf7e9ead1440d024fd3314c4"; url = "mirror://maven/org/scala-sbt/util-interface/1.3.0/util-interface-1.3.0.jar"; })
    (artifact { sha1 = "b5a4b6d16ab13e34a88fae84c35cd5d68cac922c"; url = "mirror://maven/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar"; })
    (artifact { sha1 = "55d4c73dd343efebd236abfeb367c9ef41d55063"; url = "mirror://maven/org/slf4j/slf4j-nop/1.7.30/slf4j-nop-1.7.30.jar"; })
    (artifact { sha1 = "9250a8d4b5bf9f9b328f2e58fc1537370105c511"; url = "https://scala-ci.typesafe.com/artifactory/scala-integration/org/scala-lang/scala-library/2.13.5-bin-aab85b1/scala-library-2.13.5-bin-aab85b1.jar"; })
    (artifact { sha1 = "356a1c42659a35a6ff28d8968d3937d56a275cc8"; url = "https://scala-ci.typesafe.com/artifactory/scala-integration/org/scala-lang/scala-reflect/2.13.5-bin-aab85b1/scala-reflect-2.13.5-bin-aab85b1.jar"; })
  ];

  scalac-3-jars = [
    (artifact { sha1 = "dbb5e9230a91f2a6d011096c2b9c10a5a6e5f7f2"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.7.0/protobuf-java-3.7.0.jar"; })
    (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
    (artifact { sha1 = "d4f88b2c96055e1369db7ef62c622c4697873c3a"; url = "mirror://maven/org/jline/jline-reader/3.15.0/jline-reader-3.15.0.jar"; })
    (artifact { sha1 = "139202af0195c369a2848fb5a36a3e1ea59270d8"; url = "mirror://maven/org/jline/jline-terminal/3.15.0/jline-terminal-3.15.0.jar"; })
    (artifact { sha1 = "9a6ba57d3910e25e8bca4aefc90c5671abd15b2e"; url = "mirror://maven/org/jline/jline-terminal-jna/3.15.0/jline-terminal-jna-3.15.0.jar"; })
    (artifact { sha1 = "233fb30e6fdc6ecb033ed948bdd3556077d08872"; url = "mirror://maven/org/scala-lang/modules/scala-asm/7.3.1-scala-1/scala-asm-7.3.1-scala-1.jar"; })
    (artifact { sha1 = "048870f10035c734370cccb224c218d2e60ca828"; url = "mirror://maven/org/scala-lang/scala3-compiler_3.0.0-M3/3.0.0-M3/scala3-compiler_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "0cf4e8d1521b416a803ae98d444a63e80ab63dc2"; url = "mirror://maven/org/scala-lang/scala3-interfaces/3.0.0-M3/scala3-interfaces-3.0.0-M3.jar"; })
    (artifact { sha1 = "222a9b39778925d19ae16192198743f48d5a4997"; url = "mirror://maven/org/scala-lang/scala3-library_3.0.0-M3/3.0.0-M3/scala3-library_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "b6781c71dfe4a3d5980a514eec8a513f693ead95"; url = "mirror://maven/org/scala-lang/scala-library/2.13.4/scala-library-2.13.4.jar"; })
    (artifact { sha1 = "db159b7290b89203e6c7a6334f3b94f837426f2b"; url = "mirror://maven/org/scala-lang/tasty-core_3.0.0-M3/3.0.0-M3/tasty-core_3.0.0-M3-3.0.0-M3.jar"; })
    (artifact { sha1 = "1f7379ff56b1795b523838cd06ff24272104c380"; url = "mirror://maven/org/scala-sbt/compiler-interface/1.3.5/compiler-interface-1.3.5.jar"; })
    (artifact { sha1 = "edc7556e112da142bf7e9ead1440d024fd3314c4"; url = "mirror://maven/org/scala-sbt/util-interface/1.3.0/util-interface-1.3.0.jar"; })
  ];

  scalac-2-jars = [
    (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
    (artifact { sha1 = "27edf6497c4fac20b63ca4cd8788581ca86cb83e"; url = "mirror://maven/org/jline/jline/3.19.0/jline-3.19.0.jar"; })
    (artifact { sha1 = "7cae694a5a20fcc6ee61ee2b374f962eac66aeaa"; url = "https://scala-ci.typesafe.com/artifactory/scala-integration/org/scala-lang/scala-compiler/2.13.5-bin-aab85b1/scala-compiler-2.13.5-bin-aab85b1.jar"; })
    (artifact { sha1 = "9250a8d4b5bf9f9b328f2e58fc1537370105c511"; url = "https://scala-ci.typesafe.com/artifactory/scala-integration/org/scala-lang/scala-library/2.13.5-bin-aab85b1/scala-library-2.13.5-bin-aab85b1.jar"; })
    (artifact { sha1 = "356a1c42659a35a6ff28d8968d3937d56a275cc8"; url = "https://scala-ci.typesafe.com/artifactory/scala-integration/org/scala-lang/scala-reflect/2.13.5-bin-aab85b1/scala-reflect-2.13.5-bin-aab85b1.jar"; })
  ];

  scala_2_xx = buildPackages.runCommand "scalac-${crossScalaVersion}" {nativeBuildInputs=[makeWrapper];} ''makeWrapper "${buildPackages.jdk}/bin/java" $out/bin/scalac --add-flags "-cp ${lib.concatStringsSep ":" scalac-2-jars} scala.tools.nsc.Main -Ytasty-reader"'';
  scala_3_xx = buildPackages.runCommand "scalac-${scalaVersion}"      {nativeBuildInputs=[makeWrapper];} ''makeWrapper "${buildPackages.jdk}/bin/java" $out/bin/scalac --add-flags "-cp ${lib.concatStringsSep ":" scalac-3-jars} dotty.tools.dotc.Main"'';
in {
  ammonite_3_00 = stdenv.mkDerivation rec {
    pname = "ammonite-${scalaVersion}";
    version = "2.3.8+";
    src = fetchFromGitHub {
      owner = "lihaoyi";
      repo = "Ammonite";
      rev = "88d7a83e0f80d5af49e1f24b1a976e8100cba7a9"; # 2021-02-19
      sha256 = "1kdvgwl51jf7r6sqsz6drhbcw410pf4yy1d63kygv5id7v3fxqxm";
    };

    nativeBuildInputs = [ zip gnused makeWrapper jdk perl ];
    postPatch = ''
      substituteInPlace terminal/src/main/scala/ammonite/terminal/Utils.scala \
        --replace '"/usr/bin/tput"'                                 '"${ncurses}/bin/tput"'   \
        --replace '"/bin/stty"'                                     '"${coreutils}/bin/stty"' \
        --replace '"sh"'                                            '"${bash}/bin/bash"'
    '';

    buildPhase = ''
      JAVASOURCES=$(find ./amm/util/src/main -type f -name '*.java')
      SCALASOURCES1=$(find ./terminal/src/main               \
                           ./ops/src/main                    \
                           ./amm/util/src/main               \
                           ./amm/compiler/interface/src/main \
                           ./amm/interp/src/main             \
                           ./amm/interp/api/src/main         \
                           ./amm/repl/src/main               \
                           ./amm/repl/api/src/main           \
                           ./amm/runtime/src/main            \
                           -type f -name '*.scala' | perl ${./filterSourceDirs.pl} ${crossScalaVersion})
      DOTTYSOURCES=$( find ./amm/compiler/src/main/scala     \
                           ./amm/compiler/src/main/scala-3   \
                           -type f -name '*.scala')
      SCALASOURCES2=$(find ./amm/src/main                    \
                           -type f -name '*.scala')

      mkdir out-dir1 out-dir2 out-dir3

      ${scala_2_xx}/bin/scalac \
        -d out-dir1 \
        -classpath ${lib.concatStringsSep ":" deps} \
        $SCALASOURCES1 $JAVASOURCES \
        ${writeText "Constants.scala" ''
                        package ammonite
                        object Constants{
                          val version = "${version}"
                          val bspVersion = "${(lib.findFirst (x: x.artifactId=="bsp4j") null deps).version}"
                        }
                    ''}
      javac \
        -d out-dir1 \
        -cp ${lib.concatStringsSep ":" deps} \
        $JAVASOURCES

      ${scala_3_xx}/bin/scalac \
        -d out-dir2 \
        -classpath out-dir1:${lib.concatStringsSep ":" deps} \
        $DOTTYSOURCES

      ${scala_2_xx}/bin/scalac \
        -d out-dir3 \
        -classpath out-dir1:out-dir2:${lib.concatStringsSep ":" deps} \
        $SCALASOURCES2

      # list of already loaded artifacts
      echo ${lib.escapeShellArg (lib.concatStringsSep "\n" (lib.naturalSort (map (x: x.spec) deps)))} > out-dir3/amm-dependencies.txt

      (cd out-dir1; zip -r ../ammonite_${scalaVersion}-${version}.jar .)
      (cd out-dir2; zip -r ../ammonite_${scalaVersion}-${version}.jar .)
      (cd out-dir3; zip -r ../ammonite_${scalaVersion}-${version}.jar .)
    '';

    installPhase = ''
      CLASSPATH=""
      for f in ammonite_${scalaVersion}-${version}.jar ${lib.escapeShellArgs deps}; do
        jarname=$(echo "$f" | sed -E 's,.+/[0-9a-z]{32}-,,')
        install -D "$f" "$out/share/java/$jarname"
        CLASSPATH=''${CLASSPATH-}''${CLASSPATH:+:}$out/share/java/$jarname
      done

      makeWrapper "${jdk}/bin/java" $out/bin/amm \
        --add-flags "-cp $CLASSPATH ammonite.Main ${lib.optionalString (disableRemoteLogging) " --no-remote-logging"}"
    '';

    passthru = { inherit scala_2_xx scala_3_xx; };
    meta = {
      description = "Improved Scala REPL";
      longDescription = ''
        The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
        It is much more featureful than the default REPL and comes
        with a lot of ergonomic improvements and configurability
        that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
      '';
      homepage = "http://www.lihaoyi.com/Ammonite/";
      license = lib.licenses.mit;
      inherit (jdk.meta) platforms;
      maintainers = [ lib.maintainers.nequissimus ];
    };
  };
}
