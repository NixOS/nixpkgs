{ lib, stdenv, perl, callPackage, buildPackages, zip, fetchFromGitHub, makeWrapper, writeText, fetchurl, ncurses, coreutils, bash, jdk, gnused, disableRemoteLogging ? true }:

let
  artifact = callPackage ./fetchArtifact.nix {};

  common = { scala, deps }:
    stdenv.mkDerivation rec {
      pname = "ammonite-${scala.version}";
      version = "2.3.8+";
      src = fetchFromGitHub {
        owner = "lihaoyi";
        repo = "Ammonite";
        rev = "1cce53f30d8208b87173c2976a5751ebdc1ba45b"; # 2021-02-19
        sha256 = "06afx4gp5gwm8j9a6whj6h67rf00krn5vwp3xs0dzcpdhybjq2qh";
      };

      nativeBuildInputs = [ zip gnused scala makeWrapper jdk perl ];
      postPatch = ''
        substituteInPlace terminal/src/main/scala/ammonite/terminal/Utils.scala \
          --replace '"/usr/bin/tput"'                                 '"${ncurses}/bin/tput"'   \
          --replace '"/bin/stty"'                                     '"${coreutils}/bin/stty"' \
          --replace '"sh"'                                            '"${bash}/bin/bash"'
      '';

      buildPhase = ''
        SCALASOURCES=$(find . -type f -name '*.scala' | egrep -v '/test/|/out/|/readme/' | perl ${./filterSourceDirs.pl} ${scala.version})
        JAVASOURCES=$(find ./amm/util/src/main -type f -name '*.java')

        mkdir out-dir

        scalac \
          -d out-dir \
          -cp ${lib.concatStringsSep ":" deps} \
          $SCALASOURCES $JAVASOURCES \
          ${writeText "Constants.scala" ''
                          package ammonite
                          object Constants{
                            val version = "${version}"
                            val bspVersion = "${(lib.findFirst (x: x.artifactId=="bsp4j") null deps).version}"
                          }
                      ''}
        javac \
          -d out-dir \
          -cp ${lib.concatStringsSep ":" deps} \
          $JAVASOURCES

        # list of already loaded artifacts
        echo ${lib.escapeShellArg (lib.concatStringsSep "\n" (lib.naturalSort (map (x: x.spec) deps)))} > out-dir/amm-dependencies.txt

        (cd out-dir; zip -r ../ammonite_${scala.version}-${version}.jar .)
      '';

      installPhase = ''
        CLASSPATH=""
        for f in ammonite_${scala.version}-${version}.jar ${lib.escapeShellArgs deps}; do
          jarname=$(echo "$f" | sed -E 's,.+/[0-9a-z]{32}-,,')
          install -D "$f" "$out/share/java/$jarname"
          CLASSPATH=''${CLASSPATH-}''${CLASSPATH:+:}$out/share/java/$jarname
        done

        makeWrapper "${jdk}/bin/java" $out/bin/amm \
          --add-flags "-cp $CLASSPATH ammonite.Main ${lib.optionalString (disableRemoteLogging) " --no-remote-logging"}"
      '';

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
in {
  ammonite_2_12 = common {
    scala = buildPackages.scala_2_12.override{ inherit (buildPackages) jre; };
/*
produced with

```bash
export SCALAVERSION="2.12.13"
export DEPS="org.scala-lang:scala-compiler:$SCALAVERSION \
             org.scala-lang:scala-reflect:$SCALAVERSION \
             org.scala-lang.modules::scala-xml:1.+ \
             org.apache.sshd:sshd-core:1.2.+ \
             org.slf4j:slf4j-nop:1.7.+ \
             org.bouncycastle:bcprov-jdk15on:1.+ \
             org.scalameta::trees:4.3.+ \
             io.get-coursier:interface:0.0.+ \
             com.lihaoyi::os-lib:0.+ \
             com.lihaoyi::pprint:0.+ \
             com.lihaoyi::fansi:0.+ \
             com.lihaoyi::upickle:1.+ \
             com.lihaoyi::requests:0.+ \
             com.lihaoyi::mainargs:0.+ \
             com.lihaoyi::sourcecode:0.+ \
             com.lihaoyi::scalaparse:2.+ \
             org.javassist:javassist:3.21.0-GA \
             com.github.javaparser:javaparser-core:3.2.+ \
             org.jline:jline-terminal-jna:3.14.+ \
             org.jline:jline-reader:3.14.+ \
             ch.epfl.scala:bsp4j:2.0.0-M6"

sha1sum $(coursier fetch --scala-version $SCALAVERSION $DEPS | sort) | \
  perl -pe 's,(\S+)\s+\S+/maven2/(\S+),"      (artifact { sha1 = \"$1\"; url = \"mirror://maven/$2\"; })",e'
```
*/
    deps = [
      (artifact { sha1 = "ec687266052360e19106280ed861a17d52d40ff4"; url = "mirror://maven/ch/epfl/scala/bsp4j/2.0.0-M6/bsp4j-2.0.0-M6.jar"; })
      (artifact { sha1 = "83a23e10b1d35323ed8a768d48d5bfc2d2201cc5"; url = "mirror://maven/com/github/javaparser/javaparser-core/3.2.12/javaparser-core-3.2.12.jar"; })
      (artifact { sha1 = "3edcfe49d2c6053a70a2a47e4e1c2f94998a49cf"; url = "mirror://maven/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar"; })
      (artifact { sha1 = "3a3d111be1be1b745edfa7d91678a12d7ed38709"; url = "mirror://maven/com/google/guava/guava/21.0/guava-21.0.jar"; })
      (artifact { sha1 = "7ec0925cc3aef0335bbc7d57edfd42b0f86f8267"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.11.4/protobuf-java-3.11.4.jar"; })
      (artifact { sha1 = "bb6f7b3d0230af317b417fc52d1e133d76b02f2f"; url = "mirror://maven/com/lihaoyi/fansi_2.12/0.2.10/fansi_2.12-0.2.10.jar"; })
      (artifact { sha1 = "5023adca4b3e0f850a3dd949c47cace4aa845773"; url = "mirror://maven/com/lihaoyi/fastparse_2.12/2.3.1/fastparse_2.12-2.3.1.jar"; })
      (artifact { sha1 = "f23a26e2ee638f8113418c72420d36756d3738f5"; url = "mirror://maven/com/lihaoyi/geny_2.12/0.6.5/geny_2.12-0.6.5.jar"; })
      (artifact { sha1 = "c0b964732f807e2a4e5dcc11d43dcb88dcea594e"; url = "mirror://maven/com/lihaoyi/mainargs_2.12/0.2.1/mainargs_2.12-0.2.1.jar"; })
      (artifact { sha1 = "9bca27c837682209169bc35cbd0bd7c1f1da0047"; url = "mirror://maven/com/lihaoyi/os-lib_2.12/0.7.2/os-lib_2.12-0.7.2.jar"; })
      (artifact { sha1 = "470eb9c1085a7be8e854fc433d068f72815d92e0"; url = "mirror://maven/com/lihaoyi/pprint_2.12/0.6.1/pprint_2.12-0.6.1.jar"; })
      (artifact { sha1 = "9c44d244e143403eefe225babadf1c3f60c317f5"; url = "mirror://maven/com/lihaoyi/requests_2.12/0.6.5/requests_2.12-0.6.5.jar"; })
      (artifact { sha1 = "2aa8dcd5ed2193373553a7bb4e6266af5a11bf1f"; url = "mirror://maven/com/lihaoyi/scalaparse_2.12/2.3.1/scalaparse_2.12-2.3.1.jar"; })
      (artifact { sha1 = "f78257e773794d03f6a4f93880fc76841cef84e0"; url = "mirror://maven/com/lihaoyi/sourcecode_2.12/0.2.3/sourcecode_2.12-0.2.3.jar"; })
      (artifact { sha1 = "1afa90043157472924d7e97d1fdf3a034745267d"; url = "mirror://maven/com/lihaoyi/ujson_2.12/1.2.3/ujson_2.12-1.2.3.jar"; })
      (artifact { sha1 = "a37d0e9c3ce744a8de09baf9f8047b0500dc37a8"; url = "mirror://maven/com/lihaoyi/upack_2.12/1.2.3/upack_2.12-1.2.3.jar"; })
      (artifact { sha1 = "61200e40f4bd943656f36eb0f11f6cc786ca0b3e"; url = "mirror://maven/com/lihaoyi/upickle_2.12/1.2.3/upickle_2.12-1.2.3.jar"; })
      (artifact { sha1 = "74531a43d48d8fe12094d17ad591f102d9cd6fb4"; url = "mirror://maven/com/lihaoyi/upickle-core_2.12/1.2.3/upickle-core_2.12-1.2.3.jar"; })
      (artifact { sha1 = "1b4d4a3a44b91d6c3a3d6c422fbe36d27fc0fa8f"; url = "mirror://maven/com/lihaoyi/upickle-implicits_2.12/1.2.3/upickle-implicits_2.12-1.2.3.jar"; })
      (artifact { sha1 = "b4db1aa96551a12e76113646c3b3ac5c89cd89e7"; url = "mirror://maven/com/thesamet/scalapb/lenses_2.12/0.10.8/lenses_2.12-0.10.8.jar"; })
      (artifact { sha1 = "55b122d2b4113ec5477ea87fb52f9caf783240d4"; url = "mirror://maven/com/thesamet/scalapb/scalapb-runtime_2.12/0.10.8/scalapb-runtime_2.12-0.10.8.jar"; })
      (artifact { sha1 = "1499c69be11f16b0615b15c9951f2ed186748a8b"; url = "mirror://maven/io/get-coursier/interface/0.0.25/interface-0.0.25.jar"; })
      (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
      (artifact { sha1 = "4bc24a8228ba83dac832680366cf219da71dae8e"; url = "mirror://maven/org/apache/sshd/sshd-core/1.2.0/sshd-core-1.2.0.jar"; })
      (artifact { sha1 = "46a080368d38b428d237a59458f9bc915222894d"; url = "mirror://maven/org/bouncycastle/bcprov-jdk15on/1.68/bcprov-jdk15on-1.68.jar"; })
      (artifact { sha1 = "a9bc24a06267c6495439a4d998fcd49899399384"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.generator/0.8.1/org.eclipse.lsp4j.generator-0.8.1.jar"; })
      (artifact { sha1 = "4535bd0485fc3e6867b7d5ce0c74e7e7274a3ca4"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.8.1/org.eclipse.lsp4j.jsonrpc-0.8.1.jar"; })
      (artifact { sha1 = "c33ea2bd646e28de06df4695142a237c1237ccbc"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib/2.18.0/org.eclipse.xtend.lib-2.18.0.jar"; })
      (artifact { sha1 = "ad3ec3339240d8cc24a4b8f3549b559ac3bc7cdd"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.18.0/org.eclipse.xtend.lib.macro-2.18.0.jar"; })
      (artifact { sha1 = "ba7afe66b8fc19cce0c2da203c56291da74d410e"; url = "mirror://maven/org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.18.0/org.eclipse.xtext.xbase.lib-2.18.0.jar"; })
      (artifact { sha1 = "598244f595db5c5fb713731eddbb1c91a58d959b"; url = "mirror://maven/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar"; })
      (artifact { sha1 = "3ae8dbc62a23fd8ffbb2e389c6d5df2b50efa699"; url = "mirror://maven/org/jline/jline-reader/3.14.1/jline-reader-3.14.1.jar"; })
      (artifact { sha1 = "6eaf4f5a16d6250bc81b4fc046227e23e85d3783"; url = "mirror://maven/org/jline/jline-terminal/3.14.1/jline-terminal-3.14.1.jar"; })
      (artifact { sha1 = "ffdeea1ab14073e15fb23e21b27bb47b20d262f2"; url = "mirror://maven/org/jline/jline-terminal-jna/3.14.1/jline-terminal-jna-3.14.1.jar"; })
      (artifact { sha1 = "d1154c92c572055be451ec319180aa3ee5fee595"; url = "mirror://maven/org/scala-lang/modules/scala-collection-compat_2.12/2.4.0/scala-collection-compat_2.12-2.4.0.jar"; })
      (artifact { sha1 = "e22de3366a698a9f744106fb6dda4335838cf6a7"; url = "mirror://maven/org/scala-lang/modules/scala-xml_2.12/1.0.6/scala-xml_2.12-1.0.6.jar"; })
      (artifact { sha1 = "e1edfa3bb8e7fd767ddb25d3d5642aace7202881"; url = "mirror://maven/org/scala-lang/scala-compiler/2.12.13/scala-compiler-2.12.13.jar"; })
      (artifact { sha1 = "c4a2c5f551238795136cb583feef73ae78651e07"; url = "mirror://maven/org/scala-lang/scala-library/2.12.13/scala-library-2.12.13.jar"; })
      (artifact { sha1 = "9f044e6610b4f6a875fd8f055687d604040b424b"; url = "mirror://maven/org/scala-lang/scala-reflect/2.12.13/scala-reflect-2.12.13.jar"; })
      (artifact { sha1 = "0ab096e6e4dc86f6c1adf396473d2b97c9a329a0"; url = "mirror://maven/org/scalameta/common_2.12/4.3.24/common_2.12-4.3.24.jar"; })
      (artifact { sha1 = "821b3be4b09dc00a1844178d6301f80006956304"; url = "mirror://maven/org/scalameta/fastparse_2.12/1.0.1/fastparse_2.12-1.0.1.jar"; })
      (artifact { sha1 = "6a7f0f080d2e6626fdcfc64c747ad7c32eabbcfc"; url = "mirror://maven/org/scalameta/fastparse-utils_2.12/1.0.1/fastparse-utils_2.12-1.0.1.jar"; })
      (artifact { sha1 = "5440d642fdde764287c05fc1dc82255d69a1ff31"; url = "mirror://maven/org/scalameta/trees_2.12/4.3.24/trees_2.12-4.3.24.jar"; })
      (artifact { sha1 = "b5a4b6d16ab13e34a88fae84c35cd5d68cac922c"; url = "mirror://maven/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar"; })
      (artifact { sha1 = "55d4c73dd343efebd236abfeb367c9ef41d55063"; url = "mirror://maven/org/slf4j/slf4j-nop/1.7.30/slf4j-nop-1.7.30.jar"; })
    ];
  };

  ammonite_2_13 = common {
    scala = buildPackages.scala_2_13.override{ inherit (buildPackages) jre; };
/*
produced with

```bash
export SCALAVERSION="2.13.4"
export DEPS="org.scala-lang:scala-compiler:$SCALAVERSION \
             org.scala-lang:scala-reflect:$SCALAVERSION \
             org.scala-lang.modules::scala-xml:1.+ \
             org.apache.sshd:sshd-core:1.2.+ \
             org.slf4j:slf4j-nop:1.7.+ \
             org.bouncycastle:bcprov-jdk15on:1.+ \
             org.scalameta::trees:4.3.+ \
             io.get-coursier:interface:0.0.+ \
             com.lihaoyi::os-lib:0.+ \
             com.lihaoyi::pprint:0.+ \
             com.lihaoyi::fansi:0.+ \
             com.lihaoyi::upickle:1.+ \
             com.lihaoyi::requests:0.+ \
             com.lihaoyi::mainargs:0.+ \
             com.lihaoyi::sourcecode:0.+ \
             com.lihaoyi::scalaparse:2.+ \
             org.javassist:javassist:3.21.0-GA \
             com.github.javaparser:javaparser-core:3.2.+ \
             org.jline:jline-terminal-jna:3.14.+ \
             org.jline:jline-reader:3.14.+ \
             ch.epfl.scala:bsp4j:2.0.0-M6"

sha1sum $(coursier fetch --scala-version $SCALAVERSION $DEPS | sort) | \
  perl -pe 's,(\S+)\s+\S+/maven2/(\S+),"      (artifact { sha1 = \"$1\"; url = \"mirror://maven/$2\"; })",e'
```
*/
    deps = [
      (artifact { sha1 = "ec687266052360e19106280ed861a17d52d40ff4"; url = "mirror://maven/ch/epfl/scala/bsp4j/2.0.0-M6/bsp4j-2.0.0-M6.jar"; })
      (artifact { sha1 = "83a23e10b1d35323ed8a768d48d5bfc2d2201cc5"; url = "mirror://maven/com/github/javaparser/javaparser-core/3.2.12/javaparser-core-3.2.12.jar"; })
      (artifact { sha1 = "3edcfe49d2c6053a70a2a47e4e1c2f94998a49cf"; url = "mirror://maven/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar"; })
      (artifact { sha1 = "3a3d111be1be1b745edfa7d91678a12d7ed38709"; url = "mirror://maven/com/google/guava/guava/21.0/guava-21.0.jar"; })
      (artifact { sha1 = "7ec0925cc3aef0335bbc7d57edfd42b0f86f8267"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.11.4/protobuf-java-3.11.4.jar"; })
      (artifact { sha1 = "a4564b882834deb08b09984140c244f18f4ac93c"; url = "mirror://maven/com/lihaoyi/fansi_2.13/0.2.10/fansi_2.13-0.2.10.jar"; })
      (artifact { sha1 = "0e13d118269035cf9bd1b7622ccfa7d0d4c04257"; url = "mirror://maven/com/lihaoyi/fastparse_2.13/2.3.1/fastparse_2.13-2.3.1.jar"; })
      (artifact { sha1 = "8831c3af946628d4136e65d559146450a9b64c3d"; url = "mirror://maven/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5.jar"; })
      (artifact { sha1 = "ff3f950a7ed274d5c59f89ebb0e16ce1404db269"; url = "mirror://maven/com/lihaoyi/mainargs_2.13/0.2.1/mainargs_2.13-0.2.1.jar"; })
      (artifact { sha1 = "d414f8a6645f17f2885f74ba7ccba968a1518aae"; url = "mirror://maven/com/lihaoyi/os-lib_2.13/0.7.2/os-lib_2.13-0.7.2.jar"; })
      (artifact { sha1 = "b4a68c3db5ba48fad8e8bafbf7dcba608652daa8"; url = "mirror://maven/com/lihaoyi/pprint_2.13/0.6.1/pprint_2.13-0.6.1.jar"; })
      (artifact { sha1 = "1fe223e4242022bf8a90eefa67095397f04bcba0"; url = "mirror://maven/com/lihaoyi/requests_2.13/0.6.5/requests_2.13-0.6.5.jar"; })
      (artifact { sha1 = "f6abe52b049d2b7e0907bb6ad04ab1ed5027cabd"; url = "mirror://maven/com/lihaoyi/scalaparse_2.13/2.3.1/scalaparse_2.13-2.3.1.jar"; })
      (artifact { sha1 = "c9c0445f262a284fdb8fdfc31d49a299ec4a3c4e"; url = "mirror://maven/com/lihaoyi/sourcecode_2.13/0.2.3/sourcecode_2.13-0.2.3.jar"; })
      (artifact { sha1 = "0be176c15031bcbc6a310761cf61f108cbf89b67"; url = "mirror://maven/com/lihaoyi/ujson_2.13/1.2.3/ujson_2.13-1.2.3.jar"; })
      (artifact { sha1 = "0952720de0477287ca9430d120a0dcf660919ce4"; url = "mirror://maven/com/lihaoyi/upack_2.13/1.2.3/upack_2.13-1.2.3.jar"; })
      (artifact { sha1 = "c69ed10193bdb8926f7c890c33a7c9de84b140d7"; url = "mirror://maven/com/lihaoyi/upickle_2.13/1.2.3/upickle_2.13-1.2.3.jar"; })
      (artifact { sha1 = "ebfe8a71294000c9425d6023d14d881fa5686976"; url = "mirror://maven/com/lihaoyi/upickle-core_2.13/1.2.3/upickle-core_2.13-1.2.3.jar"; })
      (artifact { sha1 = "1c827a2d0141ff16c0310f02cc487f5f749d0dd1"; url = "mirror://maven/com/lihaoyi/upickle-implicits_2.13/1.2.3/upickle-implicits_2.13-1.2.3.jar"; })
      (artifact { sha1 = "8f25d8f9d4741c69290cb0ddb9d0cc3c7efaeb9c"; url = "mirror://maven/com/thesamet/scalapb/lenses_2.13/0.10.8/lenses_2.13-0.10.8.jar"; })
      (artifact { sha1 = "e1cff090bec6952d89d169d74a90f9d0da0a1a36"; url = "mirror://maven/com/thesamet/scalapb/scalapb-runtime_2.13/0.10.8/scalapb-runtime_2.13-0.10.8.jar"; })
      (artifact { sha1 = "1499c69be11f16b0615b15c9951f2ed186748a8b"; url = "mirror://maven/io/get-coursier/interface/0.0.25/interface-0.0.25.jar"; })
      (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
      (artifact { sha1 = "4bc24a8228ba83dac832680366cf219da71dae8e"; url = "mirror://maven/org/apache/sshd/sshd-core/1.2.0/sshd-core-1.2.0.jar"; })
      (artifact { sha1 = "46a080368d38b428d237a59458f9bc915222894d"; url = "mirror://maven/org/bouncycastle/bcprov-jdk15on/1.68/bcprov-jdk15on-1.68.jar"; })
      (artifact { sha1 = "a9bc24a06267c6495439a4d998fcd49899399384"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.generator/0.8.1/org.eclipse.lsp4j.generator-0.8.1.jar"; })
      (artifact { sha1 = "4535bd0485fc3e6867b7d5ce0c74e7e7274a3ca4"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.8.1/org.eclipse.lsp4j.jsonrpc-0.8.1.jar"; })
      (artifact { sha1 = "c33ea2bd646e28de06df4695142a237c1237ccbc"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib/2.18.0/org.eclipse.xtend.lib-2.18.0.jar"; })
      (artifact { sha1 = "ad3ec3339240d8cc24a4b8f3549b559ac3bc7cdd"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.18.0/org.eclipse.xtend.lib.macro-2.18.0.jar"; })
      (artifact { sha1 = "ba7afe66b8fc19cce0c2da203c56291da74d410e"; url = "mirror://maven/org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.18.0/org.eclipse.xtext.xbase.lib-2.18.0.jar"; })
      (artifact { sha1 = "598244f595db5c5fb713731eddbb1c91a58d959b"; url = "mirror://maven/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar"; })
      (artifact { sha1 = "81804b76b1b307d7b134757e228154e3291f3206"; url = "mirror://maven/org/jline/jline/3.16.0/jline-3.16.0.jar"; })
      (artifact { sha1 = "3ae8dbc62a23fd8ffbb2e389c6d5df2b50efa699"; url = "mirror://maven/org/jline/jline-reader/3.14.1/jline-reader-3.14.1.jar"; })
      (artifact { sha1 = "6eaf4f5a16d6250bc81b4fc046227e23e85d3783"; url = "mirror://maven/org/jline/jline-terminal/3.14.1/jline-terminal-3.14.1.jar"; })
      (artifact { sha1 = "ffdeea1ab14073e15fb23e21b27bb47b20d262f2"; url = "mirror://maven/org/jline/jline-terminal-jna/3.14.1/jline-terminal-jna-3.14.1.jar"; })
      (artifact { sha1 = "8aa0fd17420a634c67a856ecfe57fd36a47d6df3"; url = "mirror://maven/org/scala-lang/modules/scala-collection-compat_2.13/2.4.0/scala-collection-compat_2.13-2.4.0.jar"; })
      (artifact { sha1 = "1db2b0fb6f454a9d34971b47158ee9dbe85d4eca"; url = "mirror://maven/org/scala-lang/modules/scala-xml_2.13/1.3.0/scala-xml_2.13-1.3.0.jar"; })
      (artifact { sha1 = "81ef68b4e981502d3c4099343988ae9318112cfd"; url = "mirror://maven/org/scala-lang/scala-compiler/2.13.4/scala-compiler-2.13.4.jar"; })
      (artifact { sha1 = "b6781c71dfe4a3d5980a514eec8a513f693ead95"; url = "mirror://maven/org/scala-lang/scala-library/2.13.4/scala-library-2.13.4.jar"; })
      (artifact { sha1 = "922b2d8f4c0754fa0b2ab9bfe670aa51a1d084cb"; url = "mirror://maven/org/scala-lang/scala-reflect/2.13.4/scala-reflect-2.13.4.jar"; })
      (artifact { sha1 = "6961d1905b28c335fa0b80d3b4cbaf34598d9e64"; url = "mirror://maven/org/scalameta/common_2.13/4.3.24/common_2.13-4.3.24.jar"; })
      (artifact { sha1 = "e20637428b7995a4cb6458b98d7f2d2f6b29b091"; url = "mirror://maven/org/scalameta/fastparse_2.13/1.0.1/fastparse_2.13-1.0.1.jar"; })
      (artifact { sha1 = "5b5b9cf2d2b0445ba99cc51cf724925966ced13d"; url = "mirror://maven/org/scalameta/fastparse-utils_2.13/1.0.1/fastparse-utils_2.13-1.0.1.jar"; })
      (artifact { sha1 = "172c32443df7078b0ec70737d126e0c1f3103ca8"; url = "mirror://maven/org/scalameta/trees_2.13/4.3.24/trees_2.13-4.3.24.jar"; })
      (artifact { sha1 = "b5a4b6d16ab13e34a88fae84c35cd5d68cac922c"; url = "mirror://maven/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar"; })
      (artifact { sha1 = "55d4c73dd343efebd236abfeb367c9ef41d55063"; url = "mirror://maven/org/slf4j/slf4j-nop/1.7.30/slf4j-nop-1.7.30.jar"; })
    ];
  };
}
