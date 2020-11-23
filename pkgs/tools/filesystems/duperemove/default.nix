{ stdenv, fetchFromGitHub, libgcrypt
, pkgconfig, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite }:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    sha256 = "1a87mka2sfzhbch2jip6wlvvs0glxq9lqwmyrp359d1rmwwmqiw9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
