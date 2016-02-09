{ stdenv, fetchgit
, xlibsWrapper, mesa
, nvidia_x11 ? null
, libX11
}:

stdenv.mkDerivation {
  name = "primus-lib-20151204";

  src = fetchgit {
    url = git://github.com/amonakov/primus.git;
    rev = "d1afbf6fce2778c0751eddf19db9882e04f18bfd";
    sha256 = "8f095b5e2030cdb155a42a49873832843c1e4dc3087a6fb94d198de982609923";
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
    homepage = https://github.com/amonakov/primus;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
