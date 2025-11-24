{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  which,
  autoconf,
  automake,
  flex,
  bison,
  glibc,
  perl,
  libkrb5,
  libxslt,
  docbook_xsl,
  file,
  docbook_xml_dtd_43,
  libtool_2,
  withDevdoc ? false,
  doxygen,
  dblatex, # Extra developer documentation
  withNcurses ? false,
  ncurses, # Extra ncurses utilities. Needed for debugging and monitoring.
  withTsm ? false,
  tsm-client, # Tivoli Storage Manager Backup Client from IBM
}:

with (import ./srcs.nix { inherit fetchurl; });
let
  inherit (lib) optional optionalString optionals;

in
stdenv.mkDerivation {
  pname = "openafs";
  inherit version srcs;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf
    automake
    flex
    libxslt
    libtool_2
    perl
    which
    bison
  ]
  ++ optionals withDevdoc [
    doxygen
    dblatex
  ];

  buildInputs = [ libkrb5 ] ++ optional withNcurses ncurses;

  patches = [
    ./bosserver.patch
    ./cross-build.patch
  ]
  ++ optional withTsm ./tsmbac.patch;

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ]
  ++ optional withDevdoc "devdoc";

  enableParallelBuilding = false;

  setOutputFlags = false;

  # Makefiles don't include install targets for all new shared libs, yet.
  dontDisableStatic = true;

  preConfigure = ''
    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "$TMP"
    done

    for i in ./doc/xml/{AdminGuide,QuickStartUnix,UserGuide}/*.xml; do
      substituteInPlace "''${i}" --replace "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
        "${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd"
    done

    ./regen.sh


    configureFlagsArray=(
      "--with-krb5"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--disable-kernel-module"
      "--disable-fuse-client"
      "--with-docbook-stylesheets=${docbook_xsl}/share/xml/docbook-xsl"
      ${optionalString withTsm "--enable-tivoli-tsm"}
      ${optionalString (!withNcurses) "--disable-gtx"}
      "--disable-linux-d_splice-alias-extra-iput"
    )
  ''
  + optionalString withTsm ''
    export XBSA_CFLAGS="-Dxbsa -DNEW_XBSA -I${tsm-client}/lib64/sample -DXBSA_TSMLIB=\\\"${tsm-client}/lib64/libApiTSM64.so\\\""
  '';

  buildFlags = [ "all_nolibafs" ];

  postBuild = ''
    for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
      make -C "''${d}" index.html
    done
  ''
  + optionalString withDevdoc ''
    make dox
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/openafs/{AdminGuide,QuickStartUnix,UserGuide}
    cp -r doc/txt README LICENSE $doc/share/doc/openafs
    for d in AdminGuide QuickStartUnix UserGuide ; do
      cp "doc/xml/''${d}"/*.html "$doc/share/doc/openafs/''${d}"
    done

    cp src/tools/dumpscan/{afsdump_dirlist,afsdump_extract,afsdump_scan,dumptool} $out/bin

    rm -r $out/lib/openafs
  ''
  + optionalString withDevdoc ''
    mkdir -p $devdoc/share/devhelp/openafs/doxygen
    cp -r doc/{pdf,protocol} $devdoc/share/devhelp/openafs
    cp -r doc/doxygen/output/html $devdoc/share/devhelp/openafs/doxygen
  '';

  # remove forbidden references to $TMPDIR
  preFixup = ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  meta = with lib; {
    outputsToInstall = [
      "out"
      "doc"
      "man"
    ];
    description = "Open AFS client";
    homepage = "https://www.openafs.org";
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [
      maintainers.spacefrogg
    ];
  };
}
