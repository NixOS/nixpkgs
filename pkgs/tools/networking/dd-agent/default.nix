{ stdenv, fetchgit, python, sysstat }:

stdenv.mkDerivation rec {
    name = "dd-agent-ab14fde6f9";

    src = fetchgit {
      url = git://github.com/DataDog/dd-agent.git;
      rev = "ab14fde6f9b9f6cb3544f643cece97ef18a0d770";
      sha256 = "2615a2f122ac97363eba8973dfc6c2ce81cb61a26eb61c2988faad2abd05efc5";
    };

    buildInputs = [ python ];

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

      maintainers = [ stdenv.lib.maintainers.shlevy ];

      license = stdenv.lib.licenses.bsd3;

      platforms = stdenv.lib.platforms.all;
    };
}
