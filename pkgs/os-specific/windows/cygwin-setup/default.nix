{ lib, stdenv, fetchcvs, autoconf, automake, libtool, flex, bison, pkg-config
, zlib, bzip2, xz, libgcrypt
}:

stdenv.mkDerivation rec {
  pname = "cygwin-setup";
  version = "20131101";

  src = fetchcvs {
    cvsRoot = ":pserver:anoncvs@cygwin.com:/cvs/cygwin-apps";
    module = "setup";
    date = version;
    sha256 = "024wxaaxkf7p1i78bh5xrsqmfz7ss2amigbfl2r5w9h87zqn9aq3";
  };

  nativeBuildInputs = [ autoconf automake libtool flex bison pkg-config ];

  buildInputs = let
    mkStatic = lib.flip lib.overrideDerivation (o: {
      dontDisableStatic = true;
      configureFlags = lib.toList (o.configureFlags or []) ++ [ "--enable-static" ];
      buildInputs = map mkStatic (o.buildInputs or []);
      propagatedBuildInputs = map mkStatic (o.propagatedBuildInputs or []);
    });
  in map mkStatic [ zlib bzip2 xz libgcrypt ];

  configureFlags = [ "--disable-shared" ];

  dontDisableStatic = true;

  preConfigure = ''
    autoreconf -vfi
  '';

  installPhase = ''
    install -vD setup.exe "$out/bin/setup.exe"
  '';

  meta = {
    homepage = "https://sourceware.org/cygwin-apps/setup.html";
    description = "Tool for installing Cygwin";
    license = lib.licenses.gpl2Plus;
  };
}
