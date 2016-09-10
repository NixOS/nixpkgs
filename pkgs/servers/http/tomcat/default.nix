{ stdenv, lib, fetchurl }:

let

  common = { versionMajor, versionMinor, sha256 } @ args: stdenv.mkDerivation (rec {
    name = "apache-tomcat-${version}";
    version = "${versionMajor}.${versionMinor}";
    
    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${version}/bin/${name}.tar.gz";
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
    
    meta = {
      homepage = https://tomcat.apache.org/;
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = with lib.platforms; all;
      maintainers = with lib.maintainers; [ danbst ];
      license = [ lib.licenses.asl20 ];
    };
  });

in {

  tomcat6 = common {
    versionMajor = "6";
    versionMinor = "0.45";
    sha256 = "0ba8h86padpk23xmscp7sg70g0v8ji2jbwwriz59hxqy5zhd76wg";
  };

  tomcat7 = common {
    versionMajor = "7";
    versionMinor = "0.70";
    sha256 = "0x4chqb7kkmadmhf2hlank856hw2vpgjl14fak74ybimlcb3dwqk";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "0.37";
    sha256 = "0f9d4yxjzwdrayj5l3jyiclnmpb5lffvmsnp54qpf6m3gm7cj5i6";
  };

  tomcat85 = common {
    versionMajor = "8";
    versionMinor = "5.5";
    sha256 = "0idfxjrw5q45f531gyjnv6xjkbj9nhy2v1w4z7558z96230a0fqj";
  };
  
  tomcatUnstable = common {
    versionMajor = "9";
    versionMinor = "0.0.M10";
    sha256 = "0p3pqwz9zjvr9w73divsyaa53mbazf0icxfs06wvgxsvkbgj5gq9";
  };
  
}
