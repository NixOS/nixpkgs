{ lib
, python3
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "http2tcp";
  version = "0.5";

  src = fetchurl {
    url = "https://www.linta.de/~aehlig/http2tcp/${pname}-${version}.tar.gz";
    sha256 = "34fb83c091689dee398ca80db76487e0c39abb17cef390d845ffd888009a5caa";
  };

  buildInputs = [
    (python3.withPackages (ps: [
      ps.wsgitools
    ]))
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}}
    cp http2tcp* $out/bin
    cp Protocol $out/share/${pname}/
  '';

  meta = with lib; {
    maintainers = with maintainers; [ clkamp ];
    description = "Tool for tunneling TCP connections via HTTP GET requests";
    longDescription = ''
      The http2tcp tools allow to tunnel tcp connections (presumably
      ssh) via syntactically correct http requests. It is designed to
      work in the presence of so-called "transparent"
      store-and-forward proxies disallowing POST requests.

      It also turned out to be useful to stabilise connections where
      the client's internet connection is unreliable (frequent long
      network outages, rapidly changing IP address, etc).
    '';
    homepage = "https://www.linta.de/~aehlig/http2tcp/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
