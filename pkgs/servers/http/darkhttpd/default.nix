{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "darkhttpd";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "emikulic";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w11xq160q9yyffv4mw9ncp1n0dl50d9plmwxb0yijaaxls9i4sk";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin darkhttpd
    install -Dm444 -t $out/share/doc/${pname} README.md
    head -n 18 darkhttpd.c > $out/share/doc/${pname}/LICENSE
    runHook postInstall
  '';

  meta = with lib; {
    description = "Small and secure static webserver";
    homepage = "https://unix4lyfe.org/darkhttpd/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.all;
  };
}
