{ stdenv
, lib
, callPackages
, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, autoPatchelfHook
, callPackage
, jdk
, libX11
, musl
, component ? "ui"
}:

assert lib.asserts.assertOneOf "component" component [ "agent" "ui" ];

let
  version = "13.0.2";
  downloadVersion = lib.replaceStrings ["."] ["_"] version;

  artefacts = {
    agent = rec {
      x86_64-darwin = {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_agent_macos_${downloadVersion}.tgz";
        hash = "sha256-GJYDA6aNP+NYARDhQy7hUy5NduRzz1xpdP9FSWk1XMM=";
      };
      aarch64-darwin = x86_64-darwin;

      x86_64-linux = {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_agent_linux-x86_${downloadVersion}.tar.gz";
        hash = "sha256-kZ2/ScbOCxeXN++RDf14gdPFrZW8oox+xfK/VUFK+mY=";
      };
      i686-linux = x86_64-linux;
      aarch64-linux = {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_agent_linux-arm_${downloadVersion}.tar.gz";
        hash = "sha256-VtGAZuuhyrNL0YM5LR5NKfiIcsv10qy5n8cWlxK+IRk=";
      };
      armhf-linux = aarch64-linux;
    };

    ui = rec {
      x86_64-darwin = {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_macos_${downloadVersion}.tgz";
        hash = "sha256-Fc7inWD5LGenkitk4/2/xHZXfaP9shvmkYvpd/BkHNE=";
      };
      aarch64-darwin = x86_64-darwin;

      x86_64-linux = {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_linux_${downloadVersion}.tar.gz";
        hash = "sha256-x9I7l2ctquCqUymtlQpFXE6+u0Yg773qE6MvAxvCaEE=";
      };
      i686-linux = x86_64-linux;
      aarch64-linux = x86_64-linux;
      armhf-linux = x86_64-linux;
    };

    icon = {
      url = "https://www.ej-technologies.com/assets/content/header-product-jprofiler@2x-24bc4d84bd2a4eb641a5c8531758ff7c.png";
      hash = "sha256-XUmuqhnNv7mZ3Gb4A0HLSlfiJd5xbCExVsw3hmXHeVE=";
    };
  };

  nameApp = "JProfiler";

in stdenv.mkDerivation (finalAttrs: rec {
  pname = "jprofiler";
  inherit version;

  meta = with lib; {
    description = "JProfiler's intuitive UI helps you resolve performance bottlenecks";
    longDescription = ''
      JProfiler's intuitive UI helps you resolve performance bottlenecks,
      pin down memory leaks and understand threading issues.
    '';
    homepage = "https://www.ej-technologies.com/products/jprofiler/overview.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ catap ];
  };

  src = fetchurl artefacts.${component}.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional stdenv.isLinux [ autoPatchelfHook copyDesktopItems ];

  buildInputs = lib.optional stdenv.isLinux [ libX11 musl ];

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = meta.description;
    desktopName = nameApp;
    genericName = "Java Profiler Tool";
    categories = [ "Development" ];
  };

  dontStrip = stdenv.isDarwin;

  installPhase = ''
    runHook preInstall

    mv $PWD $out

    for f in $(find $out/bin $out/.install4j -type f -executable); do
      wrapProgram $f --set JAVA_HOME "${jdk.home}"
    done

    ${lib.optionalString (component == "ui") ''
      install -Dm644 "${fetchurl artefacts.icon}" \
        "$out/share/icons/hicolor/scalable/apps/jprofiler.png"

      '' + lib.optionalString stdenv.isDarwin ''
        mkdir -p $out/Applications
        ln -s $out/bin/${pname}.app $out/Applications/${nameApp}.app
        ln -s ${jdk.home} $out/.install4j/jre
      '';

    runHook postInstall
  '';

  passthru.tests.run = callPackage ./test.nix {
    jprofiler = finalAttrs.finalPackage;
  };
})
