{ lib, stdenv, fetchurl, makeWrapper, jdk11, nixosTests }:

stdenv.mkDerivation rec {
  pname = "metabase";
  version = "0.42.0";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "sha256-OSyRpjJW34Ltq2whGpTq48Oa4Mp/BCs/T9f9Ft7uNOE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jdk11}/bin/java $out/bin/metabase --add-flags "-jar $src"
  '';

  meta = with lib; {
    description = "The easy, open source way for everyone in your company to ask questions and learn from data";
    homepage    = "https://metabase.com";
    license     = licenses.agpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ schneefux thoughtpolice mmahut ];
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
}
