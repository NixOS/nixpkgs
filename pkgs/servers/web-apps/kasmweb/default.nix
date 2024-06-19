{ stdenv
, lib
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "kasmweb";
  version = "1.12.0";
  build = "d4fd8a";

  src = fetchzip {
    url = "https://kasm-static-content.s3.amazonaws.com/kasm_release_${version}.${build}.tar.gz";
    sha256 = "sha256-dCjWmI8gYtoMiMHVNgTg2ZROHXvT4ulynNvnKfMxURo=";
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
