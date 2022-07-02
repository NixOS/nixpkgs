{ stdenv
, lib
, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, undmg
, jdk
}:

let
  inherit (stdenv.hostPlatform) system;
  pname = "jprofiler";

  # 11.1.4 is the last version which can be unpacked by undmg
  # See: https://github.com/matthewbauer/undmg/issues/9
  version = if stdenv.isLinux then "13.0.2" else "11.1.4";
  nameApp = "JProfiler";

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

  src = if stdenv.isLinux then fetchurl {
    url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_linux_${lib.replaceStrings ["."] ["_"]  version}.tar.gz";
    sha256 = "sha256-x9I7l2ctquCqUymtlQpFXE6+u0Yg773qE6MvAxvCaEE=";
  } else fetchurl {
    url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_macos_${lib.replaceStrings ["."] ["_"]  version}.dmg";
    sha256 = "sha256-WDMGrDsMdY1//WMHgr+/YKSxHWt6A1dD1Pd/MuDOaz8=";
  };

  srcIcon = fetchurl {
    url = "https://www.ej-technologies.com/assets/content/header-product-jprofiler@2x-24bc4d84bd2a4eb641a5c8531758ff7c.png";
    sha256 = "sha256-XUmuqhnNv7mZ3Gb4A0HLSlfiJd5xbCExVsw3hmXHeVE=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = meta.description;
    desktopName = nameApp;
    genericName = "Java Profiler Tool";
    categories = [ "Development" ];
  };

  linux = stdenv.mkDerivation {
    inherit pname version src desktopItems;

    nativeBuildInputs = [ makeWrapper copyDesktopItems ];

    installPhase = ''
      runHook preInstall
      cp -r . $out

      rm -f $out/bin/updater
      rm -rf $out/bin/linux-ppc*
      rm -rf $out/bin/linux-armhf
      rm -rf $out/bin/linux-musl*

      for f in $(find $out/bin -type f -executable); do
        wrapProgram $f --set JAVA_HOME "${jdk.home}"
      done

      install -Dm644 "${srcIcon}" \
        "$out/share/icons/hicolor/scalable/apps/jprofiler.png"
      runHook postInstall
    '';

    meta = meta // { platforms = lib.platforms.linux; };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src;

    # Archive extraction via undmg fails for this particular version.
    nativeBuildInputs = [ makeWrapper undmg ];

    sourceRoot = "${nameApp}.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${nameApp}.app,bin}
      cp -R . $out/Applications/${nameApp}.app
      makeWrapper $out/Applications/${nameApp}.app/Contents/MacOS/JavaApplicationStub $out/bin/${pname}
      runHook postInstall
    '';

    meta = meta // { platforms = lib.platforms.darwin; };
  };
in
if stdenv.isDarwin then darwin else linux
