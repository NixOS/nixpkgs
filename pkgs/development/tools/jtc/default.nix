{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jtc";
  version = "1.76";

  src = fetchFromGitHub {
    owner = "ldn-softdev";
    repo = pname;
    rev = version;
    sha256 = "sha256-VATRlOOV4wBInLOm9J0Dp2vhtL5mb0Yxdl/ya0JiqEU=";
  };

  buildPhase = ''
    runHook preBuild

    $CXX -o jtc -Wall -std=gnu++14 -Ofast -pthread -lpthread jtc.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin jtc

    runHook postInstall
  '';

  meta = with lib; {
    description = "JSON manipulation and transformation tool";
    homepage = "https://github.com/ldn-softdev/jtc";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
