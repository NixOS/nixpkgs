{ stdenv, fetchFromGitHub, mono, makeWrapper, lua
, SDL2, freetype, openal, systemd, pkgconfig,
  dotnetPackages, gnome3, curl, unzip, which, python
}:

stdenv.mkDerivation rec {
  name = "openra-${version}";
  version = "20180307";

  meta = with stdenv.lib; {
    description = "Real Time Strategy game engine recreating the C&C titles";
    homepage    = "http://www.openra.net/";
    maintainers = [ maintainers.rardiol ];
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "OpenRA";
    repo = "OpenRA";
    rev = "release-${version}";
    sha256 = "05c6vrmlgzfxgfx1idqmp6czmr079px3n57q5ahnwzqvcl11a2jj";

    extraPostFetch = ''
      sed -i 's,curl,curl --insecure,g' $out/thirdparty/{fetch-thirdparty-deps,noget}.sh
      $out/thirdparty/fetch-thirdparty-deps.sh
    '';
  };

  dontStrip = true;

  buildInputs = (with dotnetPackages;
     [ NUnit3 NewtonsoftJson MonoNat FuzzyLogicLibrary SmartIrc4net SharpZipLib MaxMindGeoIP2 MaxMindDb SharpFont StyleCopMSBuild StyleCopPlusMSBuild RestSharp NUnitConsole OpenNAT ])
     ++ [ curl unzip lua gnome3.zenity ];
  nativeBuildInputs = [ curl unzip mono makeWrapper lua pkgconfig ];

  postPatch = ''
    mkdir Support
    sed -i \
      -e 's/^VERSION.*/VERSION = release-${version}/g' \
      -e '/GeoLite2-Country.mmdb.gz/d' \
      -e '/fetch-geoip-db.sh/d' \
      Makefile
    substituteInPlace thirdparty/configure-native-deps.sh --replace "locations=\"" "locations=\"${lua}/lib "
  '';

  preConfigure = ''
    makeFlags="prefix=$out"
    make version
  '';

  buildFlags = [ "DEBUG=false" "default" "man-page" ];

  doCheck = true;

  #TODO: check
  checkTarget = "nunit test";

  installTargets = [ "install" "install-linux-icons" "install-linux-desktop" "install-linux-appdata" "install-linux-mime" "install-man-page" ];

  postInstall = with stdenv.lib; let
    runtime = makeLibraryPath [ SDL2 freetype openal systemd lua ];
    binaries= makeBinPath [ which mono gnome3.zenity python ];
  in ''
    wrapProgram $out/lib/openra/launch-game.sh \
      --prefix PATH : "${binaries}" \
      --prefix LD_LIBRARY_PATH : "${runtime}"

    mkdir -p $out/bin
    makeWrapper $out/lib/openra/launch-game.sh $out/bin/openra --run "cd $out/lib/openra"
  '';
}
