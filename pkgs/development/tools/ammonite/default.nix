{ lib, stdenv, buildPackages, zip, fetchFromGitHub, writeText, writeScript, fetchurl, ncurses, coreutils, bash, scala_2_12, scala_2_13, jre, gnused, disableRemoteLogging ? true }:

let
  # fetchurl enriched with artifact info in passthru parsed out of the url
  artifact = {sha1, url}: fetchurl {
               inherit sha1 url;
               passthru = let
                            m = builtins.match ''mirror://maven/(.+)/([a-zA-Z0-9._-]+)/([a-zA-Z0-9._-]+)/[a-zA-Z0-9._-]+\.jar'' url;
                          in rec {
                            groupId = lib.replaceStrings ["/"] ["."] (lib.elemAt m 0);
                            artifactId = lib.elemAt m 1;
                            version = lib.elemAt m 2;
                            spec = "${groupId}:${artifactId}:${version}";
                          };
             };

  # it checks if paths like "./amm/compiler/src/main/scala-not-2.12.13+-2.13.1+/ammonite/compiler/MakeReporter.scala" are suitable for a particular scala version
  filterSourceDirs = writeScript "filterSourceDirs.pl" ''
    #!${buildPackages.perl}/bin/perl

    use strict;
    use List::Util qw(any);

    my $scalaVersion = $ARGV[0];
    die unless $scalaVersion =~ /^(\d+\.\d+)\.(\d+)$/;
    my ($scalaVersionMajor, $scalaVersionMinor) = @{^CAPTURE};

    sub check {
      my $code = shift;
      return !check($1)                                                                        if $code =~ /^not-(.+)/;                 # negation
      return any { check($_) } split(/-/,$code)                                                if $code =~ /-/;                         # ANY-sequence
      return $scalaVersionMajor eq $code                                                       if $code =~ /^\d+\.\d+$/;                # exact major version
      return $scalaVersionMajor eq $1 && $2 <= $scalaVersionMinor                              if $code =~ /^(\d+\.\d+)\.(\d+)\+?$/;    # open range
      return $scalaVersionMajor eq $1 && $2 <= $scalaVersionMinor && $scalaVersionMinor <= $3  if $code =~ /^(\d+\.\d+)\.(\d+)_(\d+)$/; # closed range
      die "unknown predicate $code\n";
    }

    while (<STDIN>) {
      next if /\/scala-([^\/]+)\// && !check($1);
      print
    }
  '';

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

      nativeBuildInputs = [ zip gnused ];
      postPatch = ''
        substituteInPlace terminal/src/main/scala/ammonite/terminal/Utils.scala \
          --replace '"/usr/bin/tput"'                                 '"${ncurses}/bin/tput"'   \
          --replace '"/bin/stty"'                                     '"${coreutils}/bin/stty"' \
          --replace '"sh"'                                            '"${bash}/bin/bash"'
      '';

      buildPhase = ''
        ${scala}/bin/scalac \
          -d ammonite_${scala.version}-${version}.jar \
          -cp ${lib.concatStringsSep ":" deps} \
          $(find . -type f -regex '.*\.\(scala\|java\)$' | egrep -v '/test/|/out/|/readme/' | ${filterSourceDirs} ${scala.version}) \
          ${writeText "Constants.scala" ''
                          package ammonite
                          object Constants{
                            val version = "${version}"
                            val bspVersion = "${(lib.findFirst (x: x.artifactId=="bsp4j") null deps).version}"
                          }
                      ''}

          # list of already loaded artifacts
          echo ${lib.escapeShellArg (lib.concatMapStringsSep "\n" (x: x.spec) deps)} > amm-dependencies.txt
          zip ammonite_${scala.version}-${version}.jar amm-dependencies.txt
      '';

      installPhase = ''
        CLASSPATH=""
        for f in ammonite_${scala.version}-${version}.jar ${lib.escapeShellArgs deps}; do
          jarname=$(echo "$f" | sed -E 's,.+/[0-9a-z]{32}-,,')
          install -D "$f" "$out/share/java/$jarname"
          CLASSPATH=''${CLASSPATH-}''${CLASSPATH:+:}$out/share/java/$jarname
        done

        mkdir $out/bin
        echo "#!${bash}/bin/bash"                                                                                                    > $out/bin/amm
        echo "${jre}/bin/java -cp $CLASSPATH ammonite.Main ${lib.optionalString (disableRemoteLogging) " --no-remote-logging"} \"\$@\"" >> $out/bin/amm
        chmod +x $out/bin/amm
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
        inherit (jre.meta) platforms;
        maintainers = [ lib.maintainers.nequissimus ];
      };
    };
in {
  ammonite_2_12 = common {
    scala = scala_2_12.override{ inherit jre; };
/*
produced with

```bash
export SCALAVERSION="2.12.13"
export DEPS="org.scala-lang:scala-compiler:$SCALAVERSION \
             org.scala-lang:scala-reflect:$SCALAVERSION \
             org.scala-lang.modules::scala-xml:1.3.0 \
             org.apache.sshd:sshd-core:1.2.0 \
             org.bouncycastle:bcprov-jdk15on:1.56 \
             org.scalameta::trees:4.3.20 \
             io.get-coursier:interface:0.0.21 \
             com.lihaoyi::os-lib:0.7.1 \
             com.lihaoyi::pprint:0.5.9 \
             com.lihaoyi::fansi:0.2.9 \
             com.lihaoyi::upickle:1.2.0 \
             com.lihaoyi::requests:0.6.5 \
             com.lihaoyi::mainargs:0.1.4 \
             com.lihaoyi::fansi:0.2.10 \
             com.lihaoyi::sourcecode:0.2.1 \
             com.lihaoyi::scalaparse:2.3.1 \
             org.javassist:javassist:3.21.0-GA \
             com.github.javaparser:javaparser-core:3.2.5 \
             org.jline:jline-terminal:3.14.1 \
             org.jline:jline-reader:3.14.1 \
             ch.epfl.scala:bsp4j:2.0.0-M6"

sha1sum $(coursier fetch --scala-version $SCALAVERSION $DEPS) | \
  perl -pe 's,(\S+)\s+\S+/maven2/(\S+),"    (artifact { sha1 = \"$1\"; url = \"mirror://maven/$2\"; })",e'
```
*/
    deps = [
      (artifact { sha1 = "e1edfa3bb8e7fd767ddb25d3d5642aace7202881"; url = "mirror://maven/org/scala-lang/scala-compiler/2.12.13/scala-compiler-2.12.13.jar"; })
      (artifact { sha1 = "9f044e6610b4f6a875fd8f055687d604040b424b"; url = "mirror://maven/org/scala-lang/scala-reflect/2.12.13/scala-reflect-2.12.13.jar"; })
      (artifact { sha1 = "5cdab3bcad5b44264947436c2f428d1cc69c4423"; url = "mirror://maven/org/scala-lang/modules/scala-xml_2.12/1.3.0/scala-xml_2.12-1.3.0.jar"; })
      (artifact { sha1 = "4bc24a8228ba83dac832680366cf219da71dae8e"; url = "mirror://maven/org/apache/sshd/sshd-core/1.2.0/sshd-core-1.2.0.jar"; })
      (artifact { sha1 = "a153c6f9744a3e9dd6feab5e210e1c9861362ec7"; url = "mirror://maven/org/bouncycastle/bcprov-jdk15on/1.56/bcprov-jdk15on-1.56.jar"; })
      (artifact { sha1 = "39ff00ce804b5d268c1fe75344915985b75746ef"; url = "mirror://maven/org/scalameta/trees_2.12/4.3.20/trees_2.12-4.3.20.jar"; })
      (artifact { sha1 = "d90260e94686feed9c6ed245dd788b008193a78d"; url = "mirror://maven/io/get-coursier/interface/0.0.21/interface-0.0.21.jar"; })
      (artifact { sha1 = "4e64ef7915607e58647a734cf4e4b9305cc410ee"; url = "mirror://maven/com/lihaoyi/os-lib_2.12/0.7.1/os-lib_2.12-0.7.1.jar"; })
      (artifact { sha1 = "7f23d5143ed49256cd06532d61f57d9127c8b084"; url = "mirror://maven/com/lihaoyi/pprint_2.12/0.5.9/pprint_2.12-0.5.9.jar"; })
      (artifact { sha1 = "bb6f7b3d0230af317b417fc52d1e133d76b02f2f"; url = "mirror://maven/com/lihaoyi/fansi_2.12/0.2.10/fansi_2.12-0.2.10.jar"; })
      (artifact { sha1 = "dd9a933fea0dc7a80d21d9f29cbbd4b16640c229"; url = "mirror://maven/com/lihaoyi/upickle_2.12/1.2.0/upickle_2.12-1.2.0.jar"; })
      (artifact { sha1 = "9c44d244e143403eefe225babadf1c3f60c317f5"; url = "mirror://maven/com/lihaoyi/requests_2.12/0.6.5/requests_2.12-0.6.5.jar"; })
      (artifact { sha1 = "ecd6c31e70f0a5ea14976f87c663a19656db54ea"; url = "mirror://maven/com/lihaoyi/mainargs_2.12/0.1.4/mainargs_2.12-0.1.4.jar"; })
      (artifact { sha1 = "f78257e773794d03f6a4f93880fc76841cef84e0"; url = "mirror://maven/com/lihaoyi/sourcecode_2.12/0.2.3/sourcecode_2.12-0.2.3.jar"; })
      (artifact { sha1 = "2aa8dcd5ed2193373553a7bb4e6266af5a11bf1f"; url = "mirror://maven/com/lihaoyi/scalaparse_2.12/2.3.1/scalaparse_2.12-2.3.1.jar"; })
      (artifact { sha1 = "598244f595db5c5fb713731eddbb1c91a58d959b"; url = "mirror://maven/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar"; })
      (artifact { sha1 = "c00bf4bbcaa2ecb51bcbdd483bc58b8d569bf88c"; url = "mirror://maven/com/github/javaparser/javaparser-core/3.2.5/javaparser-core-3.2.5.jar"; })
      (artifact { sha1 = "6eaf4f5a16d6250bc81b4fc046227e23e85d3783"; url = "mirror://maven/org/jline/jline-terminal/3.14.1/jline-terminal-3.14.1.jar"; })
      (artifact { sha1 = "3ae8dbc62a23fd8ffbb2e389c6d5df2b50efa699"; url = "mirror://maven/org/jline/jline-reader/3.14.1/jline-reader-3.14.1.jar"; })
      (artifact { sha1 = "ec687266052360e19106280ed861a17d52d40ff4"; url = "mirror://maven/ch/epfl/scala/bsp4j/2.0.0-M6/bsp4j-2.0.0-M6.jar"; })
      (artifact { sha1 = "c4a2c5f551238795136cb583feef73ae78651e07"; url = "mirror://maven/org/scala-lang/scala-library/2.12.13/scala-library-2.12.13.jar"; })
      (artifact { sha1 = "3a6274f658487d5bfff9af3862beff6da1e7fd52"; url = "mirror://maven/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar"; })
      (artifact { sha1 = "5fb571acd9c47d1700ea490a9baa3e86b97a238c"; url = "mirror://maven/org/scalameta/common_2.12/4.3.20/common_2.12-4.3.20.jar"; })
      (artifact { sha1 = "acea83ada23bb2647053e6a330c5310ebeb5337b"; url = "mirror://maven/com/thesamet/scalapb/scalapb-runtime_2.12/0.10.3/scalapb-runtime_2.12-0.10.3.jar"; })
      (artifact { sha1 = "821b3be4b09dc00a1844178d6301f80006956304"; url = "mirror://maven/org/scalameta/fastparse_2.12/1.0.1/fastparse_2.12-1.0.1.jar"; })
      (artifact { sha1 = "f23a26e2ee638f8113418c72420d36756d3738f5"; url = "mirror://maven/com/lihaoyi/geny_2.12/0.6.5/geny_2.12-0.6.5.jar"; })
      (artifact { sha1 = "b8297d559d45eb59cfd5838593da2bc633ebda0a"; url = "mirror://maven/com/lihaoyi/ujson_2.12/1.2.0/ujson_2.12-1.2.0.jar"; })
      (artifact { sha1 = "7407cbd2b053ce877c3cb80288d63d512236b7cd"; url = "mirror://maven/com/lihaoyi/upack_2.12/1.2.0/upack_2.12-1.2.0.jar"; })
      (artifact { sha1 = "ad0ccf40a69b4a9a25d5f947931712c45285b4d2"; url = "mirror://maven/com/lihaoyi/upickle-implicits_2.12/1.2.0/upickle-implicits_2.12-1.2.0.jar"; })
      (artifact { sha1 = "64470d10200b8bb288f2f61a922ae033ec94a307"; url = "mirror://maven/org/scala-lang/modules/scala-collection-compat_2.12/2.1.6/scala-collection-compat_2.12-2.1.6.jar"; })
      (artifact { sha1 = "5023adca4b3e0f850a3dd949c47cace4aa845773"; url = "mirror://maven/com/lihaoyi/fastparse_2.12/2.3.1/fastparse_2.12-2.3.1.jar"; })
      (artifact { sha1 = "a9bc24a06267c6495439a4d998fcd49899399384"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.generator/0.8.1/org.eclipse.lsp4j.generator-0.8.1.jar"; })
      (artifact { sha1 = "4535bd0485fc3e6867b7d5ce0c74e7e7274a3ca4"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.8.1/org.eclipse.lsp4j.jsonrpc-0.8.1.jar"; })
      (artifact { sha1 = "da83b4fc3aea8a85dc220071838752c89d6edf88"; url = "mirror://maven/com/thesamet/scalapb/lenses_2.12/0.10.3/lenses_2.12-0.10.3.jar"; })
      (artifact { sha1 = "7ec0925cc3aef0335bbc7d57edfd42b0f86f8267"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.11.4/protobuf-java-3.11.4.jar"; })
      (artifact { sha1 = "6a7f0f080d2e6626fdcfc64c747ad7c32eabbcfc"; url = "mirror://maven/org/scalameta/fastparse-utils_2.12/1.0.1/fastparse-utils_2.12-1.0.1.jar"; })
      (artifact { sha1 = "2008bd8f79075ea6aebe72bde7ce39b51872059d"; url = "mirror://maven/com/lihaoyi/upickle-core_2.12/1.2.0/upickle-core_2.12-1.2.0.jar"; })
      (artifact { sha1 = "c33ea2bd646e28de06df4695142a237c1237ccbc"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib/2.18.0/org.eclipse.xtend.lib-2.18.0.jar"; })
      (artifact { sha1 = "3edcfe49d2c6053a70a2a47e4e1c2f94998a49cf"; url = "mirror://maven/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar"; })
      (artifact { sha1 = "ba7afe66b8fc19cce0c2da203c56291da74d410e"; url = "mirror://maven/org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.18.0/org.eclipse.xtext.xbase.lib-2.18.0.jar"; })
      (artifact { sha1 = "ad3ec3339240d8cc24a4b8f3549b559ac3bc7cdd"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.18.0/org.eclipse.xtend.lib.macro-2.18.0.jar"; })
      (artifact { sha1 = "3a3d111be1be1b745edfa7d91678a12d7ed38709"; url = "mirror://maven/com/google/guava/guava/21.0/guava-21.0.jar"; })
    ];
  };

  ammonite_2_13 = common {
    scala = scala_2_13.override{ inherit jre; };
/*
produced with

```bash
export SCALAVERSION="2.13.4"
export DEPS="org.scala-lang:scala-compiler:$SCALAVERSION \
             org.scala-lang:scala-reflect:$SCALAVERSION \
             org.scala-lang.modules::scala-xml:1.3.0 \
             org.apache.sshd:sshd-core:1.2.0 \
             org.bouncycastle:bcprov-jdk15on:1.56 \
             org.scalameta::trees:4.3.20 \
             io.get-coursier:interface:0.0.21 \
             com.lihaoyi::os-lib:0.7.1 \
             com.lihaoyi::pprint:0.5.9 \
             com.lihaoyi::fansi:0.2.9 \
             com.lihaoyi::upickle:1.2.0 \
             com.lihaoyi::requests:0.6.5 \
             com.lihaoyi::mainargs:0.1.4 \
             com.lihaoyi::fansi:0.2.10 \
             com.lihaoyi::sourcecode:0.2.1 \
             com.lihaoyi::scalaparse:2.3.1 \
             org.javassist:javassist:3.21.0-GA \
             com.github.javaparser:javaparser-core:3.2.5 \
             org.jline:jline-terminal:3.14.1 \
             org.jline:jline-reader:3.14.1 \
             ch.epfl.scala:bsp4j:2.0.0-M6"

sha1sum $(coursier fetch --scala-version $SCALAVERSION $DEPS) | \
  perl -pe 's,(\S+)\s+\S+/maven2/(\S+),"      (artifact { sha1 = \"$1\"; url = \"mirror://maven/$2\"; })",e'
```
*/
    deps = [
      (artifact { sha1 = "81ef68b4e981502d3c4099343988ae9318112cfd"; url = "mirror://maven/org/scala-lang/scala-compiler/2.13.4/scala-compiler-2.13.4.jar"; })
      (artifact { sha1 = "922b2d8f4c0754fa0b2ab9bfe670aa51a1d084cb"; url = "mirror://maven/org/scala-lang/scala-reflect/2.13.4/scala-reflect-2.13.4.jar"; })
      (artifact { sha1 = "1db2b0fb6f454a9d34971b47158ee9dbe85d4eca"; url = "mirror://maven/org/scala-lang/modules/scala-xml_2.13/1.3.0/scala-xml_2.13-1.3.0.jar"; })
      (artifact { sha1 = "4bc24a8228ba83dac832680366cf219da71dae8e"; url = "mirror://maven/org/apache/sshd/sshd-core/1.2.0/sshd-core-1.2.0.jar"; })
      (artifact { sha1 = "a153c6f9744a3e9dd6feab5e210e1c9861362ec7"; url = "mirror://maven/org/bouncycastle/bcprov-jdk15on/1.56/bcprov-jdk15on-1.56.jar"; })
      (artifact { sha1 = "ab7691342252c0fe3ae1220de09ab8347381f587"; url = "mirror://maven/org/scalameta/trees_2.13/4.3.20/trees_2.13-4.3.20.jar"; })
      (artifact { sha1 = "d90260e94686feed9c6ed245dd788b008193a78d"; url = "mirror://maven/io/get-coursier/interface/0.0.21/interface-0.0.21.jar"; })
      (artifact { sha1 = "85277f4ab4725654aecbec0ef4367274e3526055"; url = "mirror://maven/com/lihaoyi/os-lib_2.13/0.7.1/os-lib_2.13-0.7.1.jar"; })
      (artifact { sha1 = "bb47610f8df4d3ef1fb42e7d29f00c6cacf3116d"; url = "mirror://maven/com/lihaoyi/pprint_2.13/0.5.9/pprint_2.13-0.5.9.jar"; })
      (artifact { sha1 = "a4564b882834deb08b09984140c244f18f4ac93c"; url = "mirror://maven/com/lihaoyi/fansi_2.13/0.2.10/fansi_2.13-0.2.10.jar"; })
      (artifact { sha1 = "6a9fdc473b8f86be977d0b02d0a036d448315b36"; url = "mirror://maven/com/lihaoyi/upickle_2.13/1.2.0/upickle_2.13-1.2.0.jar"; })
      (artifact { sha1 = "1fe223e4242022bf8a90eefa67095397f04bcba0"; url = "mirror://maven/com/lihaoyi/requests_2.13/0.6.5/requests_2.13-0.6.5.jar"; })
      (artifact { sha1 = "4b0ed830a50f9482ba3c692752c34829f90510cf"; url = "mirror://maven/com/lihaoyi/mainargs_2.13/0.1.4/mainargs_2.13-0.1.4.jar"; })
      (artifact { sha1 = "c9c0445f262a284fdb8fdfc31d49a299ec4a3c4e"; url = "mirror://maven/com/lihaoyi/sourcecode_2.13/0.2.3/sourcecode_2.13-0.2.3.jar"; })
      (artifact { sha1 = "f6abe52b049d2b7e0907bb6ad04ab1ed5027cabd"; url = "mirror://maven/com/lihaoyi/scalaparse_2.13/2.3.1/scalaparse_2.13-2.3.1.jar"; })
      (artifact { sha1 = "598244f595db5c5fb713731eddbb1c91a58d959b"; url = "mirror://maven/org/javassist/javassist/3.21.0-GA/javassist-3.21.0-GA.jar"; })
      (artifact { sha1 = "c00bf4bbcaa2ecb51bcbdd483bc58b8d569bf88c"; url = "mirror://maven/com/github/javaparser/javaparser-core/3.2.5/javaparser-core-3.2.5.jar"; })
      (artifact { sha1 = "6eaf4f5a16d6250bc81b4fc046227e23e85d3783"; url = "mirror://maven/org/jline/jline-terminal/3.14.1/jline-terminal-3.14.1.jar"; })
      (artifact { sha1 = "3ae8dbc62a23fd8ffbb2e389c6d5df2b50efa699"; url = "mirror://maven/org/jline/jline-reader/3.14.1/jline-reader-3.14.1.jar"; })
      (artifact { sha1 = "ec687266052360e19106280ed861a17d52d40ff4"; url = "mirror://maven/ch/epfl/scala/bsp4j/2.0.0-M6/bsp4j-2.0.0-M6.jar"; })
      (artifact { sha1 = "b6781c71dfe4a3d5980a514eec8a513f693ead95"; url = "mirror://maven/org/scala-lang/scala-library/2.13.4/scala-library-2.13.4.jar"; })
      (artifact { sha1 = "81804b76b1b307d7b134757e228154e3291f3206"; url = "mirror://maven/org/jline/jline/3.16.0/jline-3.16.0.jar"; })
      (artifact { sha1 = "6eb9d07456c56b9c2560722e90382252f0f98405"; url = "mirror://maven/net/java/dev/jna/jna/5.3.1/jna-5.3.1.jar"; })
      (artifact { sha1 = "3a6274f658487d5bfff9af3862beff6da1e7fd52"; url = "mirror://maven/org/slf4j/slf4j-api/1.7.16/slf4j-api-1.7.16.jar"; })
      (artifact { sha1 = "a3ac866168292cc87ecb1d1a1aa3a12a66d8aff3"; url = "mirror://maven/org/scalameta/common_2.13/4.3.20/common_2.13-4.3.20.jar"; })
      (artifact { sha1 = "eec4be9930db513b43ac57a5d777036320faff70"; url = "mirror://maven/com/thesamet/scalapb/scalapb-runtime_2.13/0.10.3/scalapb-runtime_2.13-0.10.3.jar"; })
      (artifact { sha1 = "e20637428b7995a4cb6458b98d7f2d2f6b29b091"; url = "mirror://maven/org/scalameta/fastparse_2.13/1.0.1/fastparse_2.13-1.0.1.jar"; })
      (artifact { sha1 = "8831c3af946628d4136e65d559146450a9b64c3d"; url = "mirror://maven/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5.jar"; })
      (artifact { sha1 = "c813e752db936cfecfd708e2051522645f287645"; url = "mirror://maven/com/lihaoyi/ujson_2.13/1.2.0/ujson_2.13-1.2.0.jar"; })
      (artifact { sha1 = "c1e224e9c9b3eed105ded5e102224acf548ddff6"; url = "mirror://maven/com/lihaoyi/upack_2.13/1.2.0/upack_2.13-1.2.0.jar"; })
      (artifact { sha1 = "3113da7c0f648121ff2504532cec1fc9daf726f8"; url = "mirror://maven/com/lihaoyi/upickle-implicits_2.13/1.2.0/upickle-implicits_2.13-1.2.0.jar"; })
      (artifact { sha1 = "1e71ddd0a0e3f5d3ae930205b473ac19191dc739"; url = "mirror://maven/org/scala-lang/modules/scala-collection-compat_2.13/2.1.6/scala-collection-compat_2.13-2.1.6.jar"; })
      (artifact { sha1 = "0e13d118269035cf9bd1b7622ccfa7d0d4c04257"; url = "mirror://maven/com/lihaoyi/fastparse_2.13/2.3.1/fastparse_2.13-2.3.1.jar"; })
      (artifact { sha1 = "a9bc24a06267c6495439a4d998fcd49899399384"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.generator/0.8.1/org.eclipse.lsp4j.generator-0.8.1.jar"; })
      (artifact { sha1 = "4535bd0485fc3e6867b7d5ce0c74e7e7274a3ca4"; url = "mirror://maven/org/eclipse/lsp4j/org.eclipse.lsp4j.jsonrpc/0.8.1/org.eclipse.lsp4j.jsonrpc-0.8.1.jar"; })
      (artifact { sha1 = "849059166184a69dae78cdacfe4fdcefd68be8a9"; url = "mirror://maven/com/thesamet/scalapb/lenses_2.13/0.10.3/lenses_2.13-0.10.3.jar"; })
      (artifact { sha1 = "7ec0925cc3aef0335bbc7d57edfd42b0f86f8267"; url = "mirror://maven/com/google/protobuf/protobuf-java/3.11.4/protobuf-java-3.11.4.jar"; })
      (artifact { sha1 = "5b5b9cf2d2b0445ba99cc51cf724925966ced13d"; url = "mirror://maven/org/scalameta/fastparse-utils_2.13/1.0.1/fastparse-utils_2.13-1.0.1.jar"; })
      (artifact { sha1 = "6da71e8114b7668bef7fa6b3387a31f64b13e853"; url = "mirror://maven/com/lihaoyi/upickle-core_2.13/1.2.0/upickle-core_2.13-1.2.0.jar"; })
      (artifact { sha1 = "c33ea2bd646e28de06df4695142a237c1237ccbc"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib/2.18.0/org.eclipse.xtend.lib-2.18.0.jar"; })
      (artifact { sha1 = "3edcfe49d2c6053a70a2a47e4e1c2f94998a49cf"; url = "mirror://maven/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar"; })
      (artifact { sha1 = "ba7afe66b8fc19cce0c2da203c56291da74d410e"; url = "mirror://maven/org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.18.0/org.eclipse.xtext.xbase.lib-2.18.0.jar"; })
      (artifact { sha1 = "ad3ec3339240d8cc24a4b8f3549b559ac3bc7cdd"; url = "mirror://maven/org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.18.0/org.eclipse.xtend.lib.macro-2.18.0.jar"; })
      (artifact { sha1 = "3a3d111be1be1b745edfa7d91678a12d7ed38709"; url = "mirror://maven/com/google/guava/guava/21.0/guava-21.0.jar"; })
    ];
  };
}
