{ stdenv, lib, fetchurl }:

let

  common = { versionMajor, versionMinor, sha256 }: stdenv.mkDerivation (rec {
    pname = "apache-tomcat";
    version = "${versionMajor}.${versionMinor}";

    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${version}/bin/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    outputs = [ "out" "webapps" ];
    installPhase =
      ''
        mkdir $out
        mv * $out
        mkdir -p $webapps/webapps
        mv $out/webapps $webapps/
      '';

    meta = with lib; {
      homepage = "https://tomcat.apache.org/";
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = platforms.all;
      maintainers = [ ];
      license = [ licenses.asl20 ];
<<<<<<< HEAD
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  });

in {
  tomcat9 = common {
    versionMajor = "9";
<<<<<<< HEAD
    versionMinor = "0.75";
    sha256 = "sha256-VWfKg789z+ns1g3hDsCZFYQ+PsdqUEBeBHCihkGZelk=";
=======
    versionMinor = "0.68";
    sha256 = "sha256-rxsv8zEIIbTel4CqIuncS5pellGwgHamKRa0KgzsOF0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  tomcat10 = common {
    versionMajor = "10";
    versionMinor = "0.27";
    sha256 = "sha256-N2atmOdhVrGx88eXOc9Wziq8kn7IWzTeFyFpir/5HLc=";
  };
}
