{ stdenv
, fetchurl
, lib
, makeWrapper
, undmg
, unzip
}:
stdenv.mkDerivation rec {
  pname = "fig";
  appname = "Fig";
  binname = "fig-darwin-universal";
  version = "1.0.56";
  revision = "414";
  src = fetchurl {
    name = "fig-${version}.dmg";
    url = "https://versions.withfig.com/fig%20${revision}.dmg";
    sha256 = "04cfvmxk187y4b0275b9mdy2y2c1vmvx4r95g0w0gwywzvz0p0rf";
  };

  meta = with lib; {
    description = "Adds IDE-style autocomplete to your existing terminal";
    homepage = "https://fig.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ opeik ];
    platforms = platforms.darwin;
  };

  sourceRoot = "${appname}.app";
  nativeBuildInputs = [ makeWrapper undmg unzip ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appname}.app,bin}
    cp -R . $out/Applications/${appname}.app
    makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${binname} $out/bin/${pname}
    runHook postInstall
  '';
}
