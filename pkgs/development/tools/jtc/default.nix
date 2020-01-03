{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jtc";
  version = "1.74";

  src = fetchFromGitHub {
    owner = "ldn-softdev";
    repo = pname;
    rev = version;
    sha256 = "04hzamgs4k0x58cf4dw0a46kyw79yvcd5vazbklbjl6ap3rmnrx3";
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
