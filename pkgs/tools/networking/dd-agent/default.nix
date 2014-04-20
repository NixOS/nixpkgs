{ stdenv, fetchurl, python, sysstat, unzip, tornado, makeWrapper }:

stdenv.mkDerivation rec {
    version = "4.2.0";
    name = "dd-agent-${version}";

    src = fetchurl {
      url = "https://github.com/DataDog/dd-agent/archive/${version}.zip";
      sha256 = "0lp3h3flb50i64kgkj9kyyf3p1xm0nipxi22w5pmhb71l678d216";
    };

    buildInputs = [ python unzip makeWrapper ];
    propagatedBuildInputs = [ python tornado ];

    postUnpack = "export sourceRoot=$sourceRoot/packaging";

    makeFlags = [ "BUILD=$(out)" ];

    installTargets = [ "install_base" "install_full" ];

    postInstall = ''
      mv $out/usr/* $out
      rmdir $out/usr
      wrapProgram $out/bin/dd-forwarder --prefix PYTHONPATH : $PYTHONPATH
    '';

    meta = {
      description = "Event collector for the DataDog analysis service";

      homepage = http://www.datadoghq.com;

      maintainers = [ stdenv.lib.maintainers.iElectric ];

      license = stdenv.lib.licenses.bsd3;

      platforms = stdenv.lib.platforms.all;
    };
}
