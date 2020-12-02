{ stdenv, callPackage, fetchurl, fetchzip, fetchFromGitHub
, makeWrapper, makeDesktopItem
, bison, dex2jar, flex, icoutils, jdk, libarchive
}:

let

  # To update: Install gradle2nix from https://github.com/tadfisher/gradle2nix
  # and run in a checkout of Ghidra:
  #
  #   gradle2nix --gradle-version 5.6.3
  #
  buildGradle = callPackage ./gradle-env.nix { };

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = "Development;";
  };

  # See $sourceRoot/gradle/support/fetchDependencies.gradle
  flatFileDependencies = {
    axmlprinter2 = fetchurl {
      url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/android4me/AXMLPrinter2.jar";
      sha256 = "0vcxylpx1kqmh6a5km2cix2j3dc1gbns60njr3g6vbxbns707v80";
    };
    hfsexplorer = fetchzip {
      url = "https://sourceforge.net/projects/catacombae/files/HFSExplorer/0.21/hfsexplorer-0_21-bin.zip";
      sha256 = "08cq6ng16xb5v7mcgv02sljxqwjpd5lvqshm7fqmj7d8spzsasv7";
      stripRoot = false;
    };
    yajsw = fetchurl {
      url = "https://sourceforge.net/projects/yajsw/files/yajsw/yajsw-stable-12.12/yajsw-stable-12.12.zip";
      sha256 = "08bkgb55fvvc63pxg0apqjsap2kmwmznv82g5jcikfrsx6qzr60k";
    };
  };

in buildGradle rec {
  pname = "ghidra";
  version = "9.2";

  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = pname;
    rev = "Ghidra_${version}_build";
    sha256 = "16k2v1ldxsg0hsjns8vd6nbifcib13446pxi86hwdwnxni03p0iw";
  };

  envSpec = ./gradle-env.json;
  nativeBuildInputs = [ bison flex icoutils libarchive makeWrapper ];
  buildJdk = jdk;
  gradleFlags = [ "buildGhidra" ];

  # See $sourceRoot/gradle/support/fetchDependencies.gradle
  postUnpack = with flatFileDependencies; ''
    mkdir -p $sourceRoot/flatRepo
    ln -s ${dex2jar}/lib/dex2jar/lib/dex-*.jar $sourceRoot/flatRepo/
    ln -s ${axmlprinter2} $sourceRoot/flatRepo/AXMLPrinter2.jar
    ln -s ${hfsexplorer}/lib/{csframework.jar,hfsx_dmglib.jar,hfsx.jar,iharder-base64.jar} $sourceRoot/flatRepo/

    mkdir -p $sourceRoot/Ghidra/Features/GhidraServer/build/
    ln -s ${yajsw} $sourceRoot/Ghidra/Features/GhidraServer/build/$(stripHash ${yajsw})
  '';

  postPatch = ''
    substituteInPlace Ghidra/application.properties \
      --replace "application.release.name=DEV" "application.release.name=PUBLIC"

    substituteInPlace Ghidra/RuntimeScripts/Common/support/launch.properties \
      --replace "JAVA_HOME_OVERRIDE=" "JAVA_HOME_OVERRIDE=${jdk.home}"
  '';

  extraInit = ''
    gradle.projectsLoaded {
      allprojects {
        repositories {
          flatDir name: "flat", dirs:["$rootProject.projectDir/flatRepo"]
        }
      }
    }
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/applications,share/ghidra}
    bsdtar -x -f build/dist/ghidra*.zip -C $out/share/ghidra --strip-components 1

    makeWrapper $out/share/ghidra/ghidraRun $out/bin/ghidra \
      --prefix PATH : ${stdenv.lib.makeBinPath [ jdk ]}

    ln -s ${desktopItem}/share/applications/* $out/share/applications

    icotool -x "Ghidra/RuntimeScripts/Windows/support/ghidra.ico"
    rm ghidra_4_40x40x32.png
    for f in ghidra_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/ghidra.png"
    done
  '';

  meta = with stdenv.lib; {
    description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    homepage = "https://ghidra-sre.org/";
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ ck3d govanify ];
  };
}
