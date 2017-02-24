{ stdenv, fetchFromGitHub, autoreconfHook, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "Blackbird";
  version = "2017-02-20";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "51eaa1853675866e2e4bd026876162b35ab1a196";
    sha256 = "06d040s5jmw9v6fkif6zjcd3lp56dmvwchcwflinc165iazbp5n2";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk-engine-murrine ];

  meta = {
    description = "Dark Desktop Suite for Gtk, Xfce and Metacity";
    homepage = http://github.com/shimmerproject/Blackbird;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
