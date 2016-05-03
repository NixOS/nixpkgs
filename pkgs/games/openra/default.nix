{ stdenv, fetchurl, mono, makeWrapper, lua
, SDL2, freetype, openal, systemd, pkgconfig,
  dotnetPackages, gnome3
}:

let
  version = "20151224";
in stdenv.mkDerivation rec {
  name = "openra-${version}";

  meta = with stdenv.lib; {
    description = "Real Time Strategy game engine recreates the C&C titles";
    homepage    = "http://www.open-ra.org/";
    maintainers = [ maintainers.rardiol ];
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/OpenRA/OpenRA/archive/release-${version}.tar.gz";
    sha256 = "0dgaxy1my5r3sr3l3gw79v89dsc7179pasj2bibswlv03wsjgqbi";
  };

  dontStrip = true;

  buildInputs = with dotnetPackages;
     [ NUnit NewtonsoftJson MonoNat FuzzyLogicLibrary SmartIrc4net SharpZipLib MaxMindGeoIP2 MaxMindDb SharpFont StyleCopMSBuild StyleCopPlusMSBuild RestSharp ]
     ++ [ lua gnome3.zenity ];
  nativeBuildInputs = [ mono makeWrapper lua pkgconfig ];

  patchPhase = ''
    sed -i 's/^VERSION.*/VERSION = release-${version}/g' Makefile
    substituteInPlace thirdparty/configure-native-deps.sh --replace "locations=\"" "locations=\"${lua}/lib "
    substituteInPlace Makefile --replace "@./thirdparty/fetch-geoip-db.sh" ""
  '';

  preConfigure = ''
    makeFlags="prefix=$out"
    make version
  '';

  preBuild = let dotnetPackagesDlls = with dotnetPackages; [
    "${MonoNat}/lib/dotnet/Mono.Nat/net40/Mono.Nat.dll"
    "${FuzzyLogicLibrary}/lib/dotnet/FuzzyLogicLibrary/Release/FuzzyLogicLibrary.dll"
    "${SmartIrc4net}/lib/dotnet/SmartIrc4net/net40/SmarIrc4net*"
    "${SharpZipLib}/lib/dotnet/SharpZipLib/20/ICSharpCode.SharpZipLib.dll"
    "${MaxMindGeoIP2}/lib/dotnet/MaxMind.GeoIP2/net40/MaxMind.GeoIP2*"
    "${MaxMindDb}/lib/dotnet/MaxMind.Db/net40/MaxMind.Db.*"
    "${SharpFont}/lib/dotnet/SharpFont/net20/SharpFont.dll"
    "${SharpFont}/lib/dotnet/SharpFont/SharpFont.dll.config"
    "${StyleCopMSBuild}/lib/dotnet/StyleCop.MSBuild/StyleCop*.dll"
    "${StyleCopPlusMSBuild}/lib/dotnet/StyleCopPlus.MSBuild/StyleCopPlus.dll"
    "${RestSharp}/lib/dotnet/RestSharp/net4-client/RestSharp.dll"
    "${NUnit}/lib/dotnet/NUnit/nunit.framework.*"
    "${NewtonsoftJson}/lib/dotnet/Newtonsoft.Json/Newtonsoft.Json.dll"
    ];
    movePackages = [
      ( let filename = "Eluant.dll"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/Eluant/releases/download/20140425/${filename}";
          sha256 = "1c20whz7dzfhg3szd62rvb79745x5iwrd5pp62j3bbj1q9wpddmb";
        }; target = filename; })

      ( let filename = "SDL2-CS.dll"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/SDL2-CS/releases/download/20150709/${filename}";
          sha256 = "0ms75w9w0x3dzpg5g1ym5nb1id7pmagbzqx0am7h8fq4m0cqddmc";
        }; target = filename; })

      ( let filename = "GeoLite2-Country.mmdb.gz"; in { origin = fetchurl {
          url = "http://geolite.maxmind.com/download/geoip/database/${filename}";
          sha256 = "0lr978pipk5q2z3x011ps4fx5nfc3hsal7jb77fc60aa6iscr05m";
        }; target = filename; })
    ];
  in ''
    mkdir thirdparty/download/

    ${stdenv.lib.concatMapStringsSep "\n" (from: "cp ${from} thirdparty/download") dotnetPackagesDlls}
    ${stdenv.lib.concatMapStringsSep "\n" ({origin, target}: "cp ${origin} thirdparty/download/${target}") movePackages}

    make dependencies
  '';

  #todo: man-page
  buildFlags = [ "DEBUG=false" "default" ];

  installTargets = [ "install" "install-linux-icons" "install-linux-desktop" "install-linux-appdata" "install-linux-mime" ];

  postInstall = with stdenv.lib; let
    runtime = makeLibraryPath [ SDL2 freetype openal systemd lua ];
  in ''
    wrapProgram $out/lib/openra/launch-game.sh \
      --prefix PATH : "${mono}/bin" \
      --set PWD $out/lib/openra/ \
      --prefix LD_LIBRARY_PATH : "${runtime}"

    mkdir -p $out/bin
    echo -e "#!${stdenv.shell}\ncd $out/lib/openra && $out/lib/openra/launch-game.sh" > $out/bin/openra
    chmod +x $out/bin/openra
  '';
}
