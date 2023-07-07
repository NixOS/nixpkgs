{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "5.3.0";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "sha256-RUN0HbrDlUt7fMDjSHaIoTyOchSmfsMQZyATZmz2zY0=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = lib.licenses.mit;
  };

}
