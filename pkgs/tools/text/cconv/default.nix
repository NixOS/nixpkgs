{ stdenv, fetchurl, autoreconfHook }:
let version = "0.6.3"; in
  stdenv.mkDerivation {
  name = "cconv-${version}";
  
  src = fetchurl {
    url = "https://github.com/xiaoyjy/cconv/archive/v${version}.tar.gz";
    sha256 = "82f46a94829f5a8157d6f686e302ff5710108931973e133d6e19593061b81d84";
  };

  nativeBuildInputs = [ autoreconfHook ];
  
  meta = with stdenv.lib; {
    description = "A iconv based simplified-traditional chinese conversion tool";
    homepage = https://github.com/xiaoyjy/cconv;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.redfish64 ];
  };
}
