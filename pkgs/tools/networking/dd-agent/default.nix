{ stdenv, fetchurl, python, sysstat, unzip }:

stdenv.mkDerivation rec {
    version = "4.0.1";
    name = "dd-agent-${version}";

    src = fetchurl {
      url = "https://github.com/DataDog/dd-agent/archive/${version}.zip";
      sha256 = "0gybdbjkj7qwnzic03xkypagb30zhm22gp3nkwrdhi8fdmwz3nm1";
    };

    buildInputs = [ python unzip ];
    propagatedBuildInputs = [ python ];

    postUnpack = "export sourceRoot=$sourceRoot/packaging";

    makeFlags = [ "BUILD=$(out)" ];

    installTargets = [ "install_base" "install_full" ];

    postInstall = ''
      mv $out/usr/* $out
      rmdir $out/usr
    '';

    meta = {
      description = "Event collector for the DataDog analysis service";

      homepage = http://www.datadoghq.com;

      maintainers = [ stdenv.lib.maintainers.shlevy stdenv.lib.maintainers.iElectric ];

      license = stdenv.lib.licenses.bsd3;

      platforms = stdenv.lib.platforms.all;
    };
}
