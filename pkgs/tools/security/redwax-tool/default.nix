{ lib, stdenv, fetchsvn
, autoreconfHook, pkg-config, txt2man, which
, openssl, apr, aprutil
}:

stdenv.mkDerivation rec {
  pname = "redwax-tool";
  version = "0.9.1";

  src = fetchsvn {
    url = "https://source.redwax.eu/svn/redwax/rt/redwax-tool/tags/redwax-tool-${version}/";
    sha256 = "sha256-MWSB1AkkRS18UUHGq8EWv3OIXPSVHpmrdD5Eq1VdbkA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config txt2man which ];
  buildInputs = [ openssl apr aprutil ];

  meta = with lib; {
    homepage = "https://redwax.eu/rt/";
    description = "Universal certificate conversion tool";
    longDescription = ''
      Read certificates and keys from your chosen sources, filter the
      certificates and keys you're interested in, write those
      certificates and keys to the destinations of your choice.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
