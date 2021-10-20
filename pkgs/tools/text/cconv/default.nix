{ lib, stdenv, fetchurl, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "cconv";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/xiaoyjy/cconv/archive/v${version}.tar.gz";
    sha256 = "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];

  meta = with lib; {
    description = "A iconv based simplified-traditional chinese conversion tool";
    homepage = "https://github.com/xiaoyjy/cconv";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.redfish64 ];
  };
}
