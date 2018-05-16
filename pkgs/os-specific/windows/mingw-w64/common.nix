{ fetchurl }:

rec {
  version = "5.0.3";
  name = "mingw-w64-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "1d4wrjfdlq5xqpv9zg6ssw4lm8jnv6522xf7d6zbjygmkswisq1a";
  };
}
