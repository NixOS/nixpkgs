{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jtc";
  version = "1.75c";

  src = fetchFromGitHub {
    owner = "ldn-softdev";
    repo = pname;
    rev = version;
    sha256 = "0q72vak1sbhigqq1a0s873knnm666sz1k3sdxbbi3bzq1x8mnykd";
  };

  buildPhase = ''
    runHook preBuild

    $CXX -o jtc -Wall -std=gnu++14 -Ofast jtc.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin jtc

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "JSON manipulation and transformation tool";
    homepage = "https://github.com/ldn-softdev/jtc";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
