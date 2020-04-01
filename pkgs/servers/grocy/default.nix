{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "grocy";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/grocy/grocy/releases/download/v${version}/grocy_${version}.zip";
    sha256 = "1fq1zlxxhpcxj67xxlgf20dia95xcimgnm13cr56sy9f2vjx58m6";
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip ${src} -d .
  '';

  patches = [ ./0001-Define-configs-with-env-vars.patch ];
  patchFlags = [ "--binary" "-p1" ];

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
