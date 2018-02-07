{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "iw-4.14";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/${name}.tar.xz";
    sha256 = "12ddd6vh6vs97135bnlyr0szv7hvpbnmfh48584frzab0z0725ph";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  makeFlags = [ "PREFIX=\${out}" ];

  meta = {
    description = "Tool to use nl80211";
    homepage = http://wireless.kernel.org/en/users/Documentation/iw;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
