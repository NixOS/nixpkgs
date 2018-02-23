{ stdenv, fetchFromGitHub, fetchpatch, alsaLib, cmake, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "apulse-${version}";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "apulse";
    rev = "v${version}";
    sha256 = "16l278q0czca2794fj388ql6qn1zrw24a0p6k7bayrrf5h32fdzd";
  };

  patches = [(fetchpatch {
    url = "https://github.com/oxij/apulse/commit/9060039d8518f39710f8afd6507a05dc8581d556.patch";
    sha256 = "1z7f5lv25fjrgzvx61qliijmf0wigh29ddi4zhqz1f5mzsphy761";
  })];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ alsaLib glib ];

  meta = with stdenv.lib; {
    description = "PulseAudio emulation for ALSA";
    homepage = https://github.com/i-rinat/apulse;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
