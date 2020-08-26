{stdenv, fetchurl, zlib}:

stdenv.mkDerivation rec {
  pname = "cramfsswap";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/c/cramfsswap/${pname}_${version}.tar.gz";
    sha256 = "0c6lbx1inkbcvvhh3y6fvfaq3w7d1zv7psgpjs5f3zjk1jysi9qd";
  };

  buildInputs = [zlib];

  installPhase = ''
    install --target $out/bin -D cramfsswap
  '';

  meta = with stdenv.lib; {
    description = "Swap endianess of a cram filesystem (cramfs)";
    homepage = "https://packages.debian.org/sid/utils/cramfsswap";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
