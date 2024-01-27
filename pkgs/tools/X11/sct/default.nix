{ lib, stdenv, fetchzip, libX11, libXrandr, xorgproto }:

stdenv.mkDerivation rec {
  pname = "sct";
  version = "0.5";

  src = fetchzip {
    url = "https://www.umaxx.net/dl/sct-0.5.tar.gz";
    sha256 = "sha256-nyYcdnCq8KcSUpc0HPCGzJI6NNrrTJLAHqPawfwPR/Q=";
  };

  buildInputs = [ libX11 libXrandr xorgproto ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://www.umaxx.net/";
    description = "A minimal utility to set display colour temperature";
    maintainers = with maintainers; [ raskin somasis ];
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
}
