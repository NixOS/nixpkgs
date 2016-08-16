{ stdenv, fetchFromGitHub
, xlibsWrapper, mesa
, nvidia_x11 ? null
, libX11
}:

stdenv.mkDerivation {
  name = "primus-lib-2015-04-28";

  src = fetchFromGitHub {
    owner = "amonakov";
    repo = "primus";
    rev = "d1afbf6fce2778c0751eddf19db9882e04f18bfd";
    sha256 = "118jm57ccawskb8vjq3a9dpa2gh72nxzvx2zk7zknpy0arrdznj1";
  };

  buildInputs = [ libX11 mesa ];

  makeFlags = [ "LIBDIR=$(out)/lib"
                "PRIMUS_libGLa=${if nvidia_x11 == null then mesa else nvidia_x11}/lib/libGL.so"
                "PRIMUS_libGLd=${mesa}/lib/libGL.so"
                "PRIMUS_LOAD_GLOBAL=${mesa}/lib/libglapi.so"
              ];

  installPhase = ''
    ln -s $out/lib/libGL.so.1 $out/lib/libGL.so
  '';

  meta = with stdenv.lib; {
    description = "Low-overhead client-side GPU offloading";
    homepage = "https://github.com/amonakov/primus";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
