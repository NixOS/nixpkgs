{ stdenv, fetchurl, python, sysstat, unzip, tornado, makeWrapper }:

stdenv.mkDerivation rec {
    version = "4.2.1";
    name = "dd-agent-${version}";

    src = fetchurl {
      url = "https://github.com/DataDog/dd-agent/archive/${version}.zip";
      sha256 = "0s1lg7rqx86z0y111105gwkknzplq149cxd7v3yg30l22wn68dmv";
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
