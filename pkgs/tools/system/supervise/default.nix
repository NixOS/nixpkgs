{ stdenv
, fetchsubmodule
, autoreconfHook
}:

stdenv.mkDerivation rec {

  name = "supervise-${version}";
  version = "1.4.0";

  src = fetchsubmodule "tools/system/supervise";

  # buildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/catern/supervise;
    description = "A minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ catern ];
  };
}
