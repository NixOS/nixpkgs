{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "grocy";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/grocy/grocy/releases/download/v${version}/grocy_${version}.zip";
    sha256 = "1d4hy495in7p0i4fnhai1yqhjhmblv1g30siggmqpjrzdiiw3bak";
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip ${src} -d .
  '';

  patches = [ ./config-locations.patch ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    description = "ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home";
    homepage = "https://grocy.info/";
  };
}
