{ stdenv, fetchFromGitHub, mono, makeWrapper, lua
, SDL2, freetype, openal, systemd, pkgconfig,
  dotnetPackages, gnome3, curl, unzip, which, python
}:

stdenv.mkDerivation rec {
  pname = "openra";
  version = "20181215";

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
    sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";

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
      --prefix LD_LIBRARY_PATH : "${runtime}" \
      --set TERM "xterm"

    mkdir -p $out/bin
    makeWrapper $out/lib/openra/launch-game.sh $out/bin/openra --run "cd $out/lib/openra"
    printf "#!/bin/sh\nexec $out/bin/openra Game.Mod=ra" > $out/bin/openra-ra
    chmod +x $out/bin/openra-ra
    printf "#!/bin/sh\nexec $out/bin/openra Game.Mod=cnc" > $out/bin/openra-cnc
    chmod +x $out/bin/openra-cnc
    printf "#!/bin/sh\nexec $out/bin/openra Game.Mod=d2k" > $out/bin/openra-d2k
    chmod +x $out/bin/openra-d2k
  '';
}
