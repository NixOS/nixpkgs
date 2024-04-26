{ lib, stdenv, makeWrapper, fetchurl, jre }:

let
  pname = "allure";
  version = "2.29.0";
in
stdenv.mkDerivation rec {
  inherit pname version;
  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  src = fetchurl {
    url = "https://github.com/allure-framework/allure2/releases/download/${version}/allure-${version}.tgz";
    sha256 = "sha256-ohcVXblnCrNs57BWmz+wUwplfIG9fOW8l08LuipNhPs=";
  };
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/share"
    cd "$out/share"
    tar xvzf $src
    mkdir -p "$out/bin"
    makeWrapper $out/share/${pname}-${version}/bin/allure $out/bin/${pname} \
      --prefix PATH : "${jre}/bin"
  '';

  dontCheck = true;

  meta = with lib; {
    homepage = "https://docs.qameta.io/allure/";
    description = "Allure Report is a flexible, lightweight multi-language test reporting tool.";
    mainProgram = "allure";
    longDescription = "Allure Report is a flexible, lightweight multi-language test reporting tool. It provides clear graphical reports and allows everyone involved in the development process to extract the maximum of information from the everyday testing process";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}

