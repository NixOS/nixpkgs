{ lib, stdenv
, gnu-config, autoreconfHook, bison, binutils-unwrapped, texinfo
, libiberty, libintl, zlib
}:

stdenv.mkDerivation {
  pname = "libbfd";
  inherit (binutils-unwrapped) version src;

  outputs = [ "out" "dev" ];

  patches = binutils-unwrapped.patches ++ [
    ./build-components-separately.patch
  ];

  # We just want to build libbfd
  postPatch = ''
    cd bfd
  '';

  postAutoreconf = ''
    echo "Updating config.guess and config.sub from ${gnu-config}"
    cp -f ${gnu-config}/config.{guess,sub} ../
  '';

  # We update these ourselves
  dontUpdateAutotoolsGnuConfigScripts = true;

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook bison texinfo ];
  buildInputs = [ libiberty zlib ] ++ lib.optionals stdenv.isDarwin [ libintl ];

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--with-system-zlib"
  ] ++ lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A library for manipulating containers of machine code";
    longDescription = ''
      BFD is a library which provides a single interface to read and write
      object files, executables, archive files, and core files in any format.
      It is associated with GNU Binutils, and elsewhere often distributed with
      it.
    '';
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}
