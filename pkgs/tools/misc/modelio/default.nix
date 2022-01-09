# Ref.: https://fzakaria.com/2020/07/20/packaging-a-maven-application-with-nix.html

{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, eclipse-sdk
, maven3
, openjdk8_headless
, atk
, cairo
, freetype
, gcc
, glib
, glibc
, gtk2
, jre8
, libXtst
, perl
, python
, swt
, webkitgtk
}:

with lib;

let
  pname = "modelio";
  version = "4.1.0";
  src = fetchFromGitHub {
    owner = "modelioopensource";
    repo = pname;
    rev = "v${version}";
    sha256 = "02hd2ldslppby0l4qzb8nr17dnzckir4rjp3bri6slj6422kfds1";
  };

  maven360 = maven3.overrideAttrs (oldAttrs: rec {
    pname = "apache-maven";
    version = "3.6.0";
    src = fetchurl {
      url = "https://archive.apache.org/dist/maven/maven-3/${version}/binaries/${pname}-${version}-bin.tar.gz";
      sha256 = "0ds61yy6hs7jgmld64b65ss6kpn5cwb186hw3i4il7vaydm386va";
    };
  });

  # maven-jdk8 = maven.override {
  #   jdk = openjdk8;
  # };

  # Perform fake build to a fixed-output derivation of the files downloaded from
  # maven central.
  dependencies = stdenv.mkDerivation {
    name = "${pname}-${version}-dependencies";
    src = ./.;

    nativeBuildInputs = [ maven360 openjdk8_headless ];

    buildPhase = ''
      while mvn \
        --define maven.repo.local=$out/.m2 \
        --define maven.wagon.rto=5000 \
        package; \
        [ $? = 1]; do
          printf "%s\n" "Timeout, restart maven to continue downloading"
        done
    '';

    # Keep only *.{pom,jar,sha1,nbm}, and delete all ephemeral files with
    # lastModfied timestamps inside.
    installPhase = ''
      find $out/.m2 -type f \
        -regex \
        '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' \
        -delete
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Ap+NMST9N34/3DX5rWndG3dxu7jrIY+wwWSUAvieGZs=";
  };
in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    eclipse-sdk
    maven360
    openjdk8_headless
  ];

  buildInputs = [
    atk # libatk
    cairo # libcairo
    freetype # libfreetype.so.6
    gcc # stdc++ 6
    glib # libglib2
    glibc # libc6
    gtk2 # libgtk2
    jre8 # java 8
    libXtst # libxtst6
    perl # plugins/**/bin/{antRun.pl,runant.pl,...}
    python # plugins/**/bin/{runant.py,...}
    swt #
    webkitgtk # libwebkitgtk-1.0
  ];

  # patches = [ ./pom.xml.patch ];

  buildPhase = ''
    # 'maven.repo.local' must be writable, so copy it out of the nix store.
    cp --archive ${dependencies}/.m2 ./ && chmod --recursive +w .m2

    pwd
    ls -la
    ls -la .m2

    mvn --offline \
      --file AGGREGATOR/pom.xml \
      --define maven.repo.local=$(pwd)/.m2 \
      package
  '';

  installPhase = ''
    mkdir --parents $out/bin

    install -D --mode=644 \
      "$src/products/target/products/org.modelio.product/linux/gtk/x86_64/Modelio 4.1/*" \
      --target $out

    ln --symbolic $out/usr/lib/modelio-open-source4.1/modelio $out/bin/modelio
    ln --symbolic $out/usr/lib/modelio-open-source4.1/modelio.sh $out/bin/modelio.sh

    rm --recursive --force $out/usr/lib/modelio-open-source4.1/jre
    ln --symbolic ${jre8.home}/jre $out/usr/lib/modelio-open-source4.1/jre

    rm --recursive --force $out/lib
    ln --symbolic ${dependencies}/.m2 $out/lib
  '';

  meta = with lib; {
    description = "Free, extensible modeling environment for UML and BPMN";
    homepage = "https://www.modelio.org";
    changelog = "https://github.com/ModelioOpenSource/Modelio/releases";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yuu ];
    license = licenses.gpl3;
  };
}
