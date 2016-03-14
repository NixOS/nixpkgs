{ fetchurl, stdenv, fetchFromGitHub, pkgconfig, mono, makeWrapper
, targetVersion ? "4.5" }:

let
   version = "2015-11-15";

  src = fetchFromGitHub {
    owner = "nant";
    repo = "nant";
    rev = "19bec6eca205af145e3c176669bbd57e1712be2a";
    sha256 = "11l5y76csn686p8i3kww9s0sxy659ny9l64krlqg3y2nxaz0fk6l";
  };

  nant-bootstrapped = stdenv.mkDerivation {
    name = "nant-bootstrapped-${version}";
    inherit src;

    buildInputs = [ pkgconfig mono makeWrapper ];

    buildFlags = "bootstrap";

    dontStrip = true;

    installPhase = ''
      mkdir -p $out/lib/nant-bootstrap
      cp -r bootstrap/* $out/lib/nant-bootstrap

      mkdir -p $out/bin
      makeWrapper "${mono}/bin/mono" $out/bin/nant \
        --add-flags "$out/lib/nant-bootstrap/NAnt.exe"
    '';
  };

in stdenv.mkDerivation {
  name = "nant-${version}";
  inherit src;

  buildInputs = [ pkgconfig mono makeWrapper nant-bootstrapped ];

  dontStrip = true;

  buildPhase = ''
    nant -t:mono-${targetVersion}
  '';

  installPhase = ''
    mkdir -p $out/lib/nant
    cp -r build/mono-${targetVersion}.unix/nant-debug/bin/* $out/lib/nant/

    mkdir -p $out/bin
    makeWrapper "${mono}/bin/mono" $out/bin/nant \
      --add-flags "$out/lib/nant/NAnt.exe"
  '';

  meta = with stdenv.lib; {
    homepage = http://nant.sourceforge.net;
    description = "NAnt is a free .NET build tool";

    longDescription = ''
      NAnt is a free .NET build tool. In theory it is kind of like make without
      make's wrinkles. In practice it's a lot like Ant.
    '';

    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zohl ];
    platforms = platforms.linux;
  };
}

