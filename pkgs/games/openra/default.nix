{ stdenv, fetchurl, mono, makeWrapper, lua
, SDL2, freetype, openal, systemd, pkgconfig,
  dotnetPackages, gnome3
}:

let
  version = "20160508";
in stdenv.mkDerivation rec {
  name = "openra-${version}";

  meta = with stdenv.lib; {
    description = "Real Time Strategy game engine recreating the C&C titles";
    homepage    = "http://www.openra.net/";
    maintainers = [ maintainers.rardiol ];
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/OpenRA/OpenRA/archive/release-${version}.tar.gz";
    sha256 = "1vr5bvdkh0n5569ga2h7ggj43vnzr37hfqkfnsis1sg4vgwrnzr7";
  };

  dontStrip = true;

  buildInputs = with dotnetPackages;
     [ NUnit3 NewtonsoftJson MonoNat FuzzyLogicLibrary SmartIrc4net SharpZipLib MaxMindGeoIP2 MaxMindDb SharpFont StyleCopMSBuild StyleCopPlusMSBuild RestSharp NUnitConsole ]
     ++ [ lua gnome3.zenity ];
  nativeBuildInputs = [ mono makeWrapper lua pkgconfig ];

  patchPhase = ''
    mkdir Support
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
    "${NUnitConsole}/lib/dotnet/NUnit.Console/*"
    "${NewtonsoftJson}/lib/dotnet/Newtonsoft.Json/Newtonsoft.Json.dll"
    ];
    movePackages = [
      ( let filename = "Eluant.dll"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/Eluant/releases/download/20160124/${filename}";
          sha256 = "1c20whz7dzfhg3szd62rvb79745x5iwrd5pp62j3bbj1q9wpddmb";
        }; target = filename; })

      ( let filename = "SDL2-CS.dll"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/SDL2-CS/releases/download/20151227/${filename}";
          sha256 = "0gqw2wg37cqhhlc2a9lfc4ndkyfi4m8bkv7ckxbawgydjlknq83n";
        }; target = filename; })

      ( let filename = "SDL2-CS.dll.config"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/SDL2-CS/releases/download/20151227/${filename}";
          sha256 = "15709iscdg44wd33szw5y0fdxwvqfjw8v3xjq6a0mm46gr7mkw7g";
        }; target = filename; })

      ( let filename = "OpenAL-CS.dll"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/OpenAL-CS/releases/download/20151227/${filename}";
          sha256 = "0lvyjkn7fqys97wym8rwlcp6ay2z059iabfvlcxhlrscjpyr2cyk";
        }; target = filename; })

      ( let filename = "OpenAL-CS.dll.config"; in { origin = fetchurl {
          url = "https://github.com/OpenRA/OpenAL-CS/releases/download/20151227/${filename}";
          sha256 = "0wcmk3dw26s93598ck5jism5609v0y233i0f1b76yilyfimg9sjq";
        }; target = filename; })

      ( let filename = "GeoLite2-Country.mmdb.gz"; in { origin = fetchurl {
          url = "http://geolite.maxmind.com/download/geoip/database/${filename}";
          sha256 = "0a82v0sj4zf5vigrn1pd6mnbqz6zl3rgk9nidqqzy836as2kxk9v";
        }; target = filename; })
    ];
  in ''
    mkdir thirdparty/download/

    ${stdenv.lib.concatMapStringsSep "\n" (from: "cp -r ${from} thirdparty/download") dotnetPackagesDlls}
    ${stdenv.lib.concatMapStringsSep "\n" ({origin, target}: "cp ${origin} thirdparty/download/${target}") movePackages}

    make dependencies
  '';

  buildFlags = [ "DEBUG=false" "default" "man-page" ];

  doCheck = true;

  #TODO: check
  checkTarget = "nunit test";

  installTargets = [ "install" "install-linux-icons" "install-linux-desktop" "install-linux-appdata" "install-linux-mime" "install-man-page" ];

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
