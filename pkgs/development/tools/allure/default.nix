
#url = https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.7.0/allure-2.7.0.tgz;
{ lib, stdenv, makeWrapper, fetchurl, jre }:

stdenv.mkDerivation rec {
  version = "2.7.0";
  pname = "allure";
  name = "${pname}-${version}";
  share-app-dir = name;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  src = fetchurl {
    url = "https://dl.bintray.com/qameta/generic/io/qameta/allure/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "181996wayplpmss5x4kiilpr4wg1mnbzbv88kr8kv3j22gwygx0g";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$out/share"
    cd "$out/share"
    tar xvzf $src

    mkdir -p "$out/bin"
    makeWrapper $out/share/${share-app-dir}/bin/allure $out/bin/${pname} \
      --prefix PATH : "${jre}/bin"
  '';

  meta = with lib; {
    homepage = "https://docs.qameta.io/allure/";
    description = ''
        A flexible lightweight multi-language test report tool
        with the possibility to add steps, attachments, parameters and so on.
      '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}

