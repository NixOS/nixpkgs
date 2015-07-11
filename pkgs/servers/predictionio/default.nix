{ stdenv, fetchurl, jdk, sbt, spark
, hbaseSupport ? true, hbase
, elasticsearchSupport ? true, elasticsearch
, postgresqlSupport ? false, postgresql }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "PredictionIO";
  version = "0.9.3";

  src = fetchurl {
    url = "https://d8k1yxp8elc6b.cloudfront.net/${name}.tar.gz";
    sha256 = "01zjx936vkmsjp8wgxi1h1kj4zh8jjq8943dlg2h0a85yqkr2ydj";
  };

  buildInputs = with stdenv.lib; [ jdk spark sbt ]
              ++ optional hbaseSupport [ hbase ]
	      ++ optional elasticsearchSupport [ elasticsearch ]
	      ++ optional postgresqlSupport [ postgresql ];

  prePatch = ''
    sed -i \
      's,export PIO_CONF_DIR=.*,[ -z "$PIO_CONF_DIR" ] \&\& echo "PIO_CONF_DIR not set" \&\& exit 1,' \
      bin/pio
    patchShebangs .
  '';

  installPhase = ''
    mkdir $out
    rm sbt/sbt*
    ln -s ${sbt}/bin/sbt sbt/sbt
    mv * $out
  '';

  meta = with stdenv.lib; {
    homepage = "http://prediction.io";
    description = "An open-source machine learning server for developers and data scientists";
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo ];
  };

}
