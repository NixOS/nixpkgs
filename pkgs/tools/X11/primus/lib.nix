{ stdenv, fetchFromGitHub
, libX11, mesa_noglu
, nvidia_x11 ? null
, libglvnd
}:

let
  aPackage =
    if nvidia_x11 == null then mesa_noglu
    else if nvidia_x11.useGLVND then libglvnd
    else nvidia_x11;

in stdenv.mkDerivation {
  name = "primus-lib-2015-04-28";

  src = fetchFromGitHub {
    owner = "amonakov";
    repo = "primus";
    rev = "d1afbf6fce2778c0751eddf19db9882e04f18bfd";
    sha256 = "118jm57ccawskb8vjq3a9dpa2gh72nxzvx2zk7zknpy0arrdznj1";
  };

  buildInputs = [ libX11 mesa_noglu ];

  makeFlags = [ "LIBDIR=$(out)/lib"
                "PRIMUS_libGLa=${aPackage}/lib/libGL.so"
                "PRIMUS_libGLd=${mesa_noglu}/lib/libGL.so"
                "PRIMUS_LOAD_GLOBAL=${mesa_noglu}/lib/libglapi.so"
              ];

  installPhase = ''
    ln -s $out/lib/libGL.so.1 $out/lib/libGL.so
  '';

  passthru.glvnd = if nvidia_x11 != null && nvidia_x11.useGLVND then nvidia_x11 else null;

  meta = with stdenv.lib; {
    description = "Low-overhead client-side GPU offloading";
    homepage = "https://github.com/amonakov/primus";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
