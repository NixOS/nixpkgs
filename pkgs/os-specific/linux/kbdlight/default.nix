{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "kbdlight-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "hobarrera";
    repo = "kbdlight";
    rev = "v${version}";
    sha256 = "1f08aid1xrbl4sb5447gkip9lnvkia1c4ap0v8zih5s9w8v72bny";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/hobarrera/kbdlight;
    description = "A very simple application that changes MacBooks' keyboard backlight level";
    license = licenses.isc;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
