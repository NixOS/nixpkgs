{ stdenv
, lib
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "kasmweb";
  version = "1.13.1";
  build = "421524";

  src = fetchzip {
    url = "https://kasm-static-content.s3.amazonaws.com/kasm_release_${version}.${build}.tar.gz";
    sha256 = "sha256-h1BT3ACm1W8Pm4y53bM4n5pNbbN+bXPxOuiZpviyjqM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    rm bin/utils/yq*
    cp -r bin conf www $out/

    runHook postInstall
  '';


  meta = with lib; {
    homepage = "https://www.kasmweb.com/";
    description = "Streaming containerized apps and desktops to end-users";
    license = licenses.unfree;
    maintainers = with maintainers; [ s1341 ];
  };
}
