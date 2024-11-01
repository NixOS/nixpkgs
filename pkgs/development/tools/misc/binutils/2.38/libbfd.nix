{ lib, stdenv
, fetchpatch, gnu-config, autoreconfHook, bison, binutils-unwrapped_2_38
, libiberty, libintl, zlib
}:

stdenv.mkDerivation {
  pname = "libbfd";
  inherit (binutils-unwrapped_2_38) version src;

  outputs = [ "out" "dev" ];

  patches = binutils-unwrapped_2_38.patches ++ [
    ./build-components-separately.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/mxe/mxe/e1d4c144ee1994f70f86cf7fd8168fe69bd629c6/src/bfd-1-disable-subdir-doc.patch";
      sha256 = "0pzb3i74d1r7lhjan376h59a7kirw15j7swwm8pz3zy9lkdqkj6q";
    })
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
  nativeBuildInputs = [ autoreconfHook bison ];
  buildInputs = [ libiberty zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libintl ];

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--with-system-zlib"
  ] ++ lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library for manipulating containers of machine code";
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
