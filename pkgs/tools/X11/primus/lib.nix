{ stdenv, fetchFromGitHub, fetchpatch
, libX11, libGL
, nvidia_x11 ? null
, libglvnd
}:

let
  aPackage =
    if nvidia_x11 == null then libGL
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

  patches = [
    # Bump buffer size for long library paths.
    (fetchpatch {
      url = "https://github.com/abbradar/primus/commit/2f429e232581c556df4f4bf210aee8a0c99c60b7.patch";
      sha256 = "1da6ynz7r7x98495i329sf821308j1rpy8prcdraqahz7p4c89nc";
    })
  ];

  buildInputs = [ libX11 libGL ];

  makeFlags = [ "LIBDIR=$(out)/lib"
                "PRIMUS_libGLa=${aPackage}/lib/libGL.so"
                "PRIMUS_libGLd=${libGL}/lib/libGL.so"
                "PRIMUS_LOAD_GLOBAL=${libGL}/lib/libglapi.so"
              ];

  installPhase = ''
    ln -s $out/lib/libGL.so.1 $out/lib/libGL.so
  '';

  passthru.glvnd = if nvidia_x11 != null && nvidia_x11.useGLVND then nvidia_x11 else null;

  meta = with stdenv.lib; {
    description = "Low-overhead client-side GPU offloading";
    homepage = https://github.com/amonakov/primus;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
