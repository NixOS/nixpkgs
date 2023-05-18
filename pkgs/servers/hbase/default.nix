{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk8_headless
, jdk11_headless
, nixosTests
}:

let common = { version, hash, jdk ? jdk11_headless, tests }:
  stdenv.mkDerivation rec {
    pname = "hbase";
    inherit version;

    src = fetchurl {
      url = "mirror://apache/hbase/${version}/hbase-${version}-bin.tar.gz";
      inherit hash;
    };

    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out
      cp -R * $out
      wrapProgram $out/bin/hbase --set-default JAVA_HOME ${jdk.home} \
        --run "test -d /etc/hadoop-conf && export HBASE_CONF_DIR=\''${HBASE_CONF_DIR-'/etc/hadoop-conf/'}" \
        --set-default HBASE_CONF_DIR "$out/conf/"
    '';

    passthru = { inherit tests; };

    meta = with lib; {
      description = "A distributed, scalable, big data store";
      homepage = "https://hbase.apache.org";
      license = licenses.asl20;
      maintainers = with lib.maintainers; [ illustris ];
      platforms = lib.platforms.linux;
    };
  };
in
{
  hbase_2_4 = common {
    version = "2.4.16";
    hash = "sha256-vMuTqS2bXFRcCsZ7bOaNLVGyOG38HhL8WlCq2MFmAaE=";
    tests.standalone = nixosTests.hbase_2_4;
  };
  hbase_2_5 = common {
    version = "2.5.3";
    hash = "sha256-h08jnDQaakpkYFHHn9qeg4JCSBtwRjv42qKLpyOVdsI=";
    tests.standalone = nixosTests.hbase2;
  };
  hbase_3_0 = common {
    version = "3.0.0-alpha-3";
    hash = "sha256-TxuiUHc2pTb9nBth1H2XrDRLla2vqM+e1uBU+yY2/EM=";
    tests.standalone = nixosTests.hbase3;
  };
}
