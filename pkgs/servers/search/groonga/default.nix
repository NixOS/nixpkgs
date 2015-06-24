{ stdenv, fetchurl, pkgconfig, libedit, zlib, lz4, jemalloc, zeromq, libevent, libmsgpack, pcre }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "groonga-${version}";
  version = "5.0.4";

  src = fetchurl {
    url = "http://packages.groonga.org/source/groonga/${name}.tar.gz";
    sha256 = "047ynici24b188cm6xmrxr26ar7ym5apl56jclzcyvbg3s97m2rk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libedit zlib lz4 jemalloc zeromq libevent libmsgpack pcre ];

  preConfigure = ''
    configureFlagsArray+=("--exec_prefix=$bin")
    configureFlagsArray+=("--libdir=$lib/lib")
    configureFlagsArray+=("--includedir=$dev/include")
    configureFlagsArray+=("--datarootdir=$data/share")
    configureFlagsArray+=("--mandir=$man/share/man")
    configureFlagsArray+=("--docdir=$doc/share/doc")
    configureFlagsArray+=("--infodir=$doc/share/info")

    export PKG_CONFIG_LIBDIR="$dev/lib/pkgconfig"
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-benchmark"
    "--without-inkscape"
    "--with-jemalloc"
    "--without-mecab"
    "--disable-groonga-httpd"
    "--disable-mruby"
  ] ++ optionals stdenv.isLinux [
    "--enable-futex"
  ];

  outputs = [ "out" "bin" "dev" "lib" "data" "man" "doc" ];

  installFlags = [
    "sysconfdir=\${data}/etc"
    "pkgconfigdir=\${dev}/lib/pkgconfig"
  ];

  postInstall = ''
    # Make dev propagate libs so that linking works
    mkdir -p $dev/nix-support
    echo "$lib" >> $dev/nix-support/propagated-native-build-inputs

    # We expect to be storing nothing in out
    # rmdir should therefore succeed
    if ! rmdir $out; then
      echo "$out unexpected contained files"
      exit 1
    fi

    # Out needs to propagate the expected installed files
    mkdir -p $out/nix-support
    echo "$bin" >> $out/nix-support/propagated-native-build-inputs
    echo "$man" >> $out/nix-support/propagated-native-build-inputs
  '';

  preFixup = ''
    # Fix the groonga executable to not include paths
    # It writes the entire config string into the --version option
    for output in "$out" "$dev" "$man" "$doc"; do
      sed -i "s,$output,$(echo "$output" | sed 's/./x/g'),g" $bin/bin/groonga
    done
    sed -i "/prefix=/d" $bin/sbin/groonga-httpd-restart

    # Fix the groonga.pc having $out references
    sed -i '/^\(libdir\|includedir\)/!s/^[a-z_]*=.*//g' $dev/lib/pkgconfig/groonga.pc
  '' + optionalString (!stdenv.isDarwin) ''
    # Fix the .la file from linking against missing libraries
    sed \
      -e "s, -lmsgpack[ '], -L${libmsgpack}/lib\0,g" \
      -e "s, -llz4[ '], -L${lz4}/lib\0,g" \
      -e "s, -ljemalloc[ '], -L${jemalloc}/lib\0,g" \
      -e "s, -lz[ '], -L${zlib}/lib\0,g" \
      -i $lib/lib/libgroonga.la
  '';

  postFixup = ''
    # Make sure there are no extraneous references
    check_references () {
      if grep -qr "$1" "$2"; then
        echo "Extraneous $1 in $2" >&2
        exit 1
      fi
    }

    check_references "$dev" "$out"
    check_references "$doc" "$out"

    check_references "$out" "$bin"
    check_references "$dev" "$bin"
    check_references "$man" "$bin"
    check_references "$doc" "$bin"

    check_references "$out" "$dev"
    check_references "$bin" "$dev"
    check_references "$man" "$dev"
    check_references "$doc" "$dev"

    check_references "$out" "$lib"
    check_references "$bin" "$lib"
    check_references "$dev" "$lib"
    check_references "$man" "$lib"
    check_references "$doc" "$lib"

    check_references "$out" "$data"
    check_references "$bin" "$data"
    check_references "$dev" "$data"
    check_references "$lib" "$data"
    check_references "$man" "$data"
    check_references "$doc" "$data"

    check_references "$out" "$man"
    check_references "$bin" "$man"
    check_references "$dev" "$man"
    check_references "$lib" "$man"
    check_references "$data" "$man"
    check_references "$doc" "$man"

    check_references "$out" "$doc"
    check_references "$dev" "$doc"
    check_references "$man" "$doc"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://groonga.org/;
    description = "an open-source fulltext search engine and column store";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
