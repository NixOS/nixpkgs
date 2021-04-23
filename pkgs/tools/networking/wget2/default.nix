{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
  # build support
, autoreconfHook
, flex
, gnulib
, lzip
, pkg-config
, python3
, texinfo
  # libraries
, brotli
, bzip2
, gpgme
, libhsts
, libidn2
, libpsl
, xz
, nghttp2
, sslSupport ? true
, openssl
, pcre2
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "wget2";
  version = "1.99.2";

  src = fetchFromGitLab {
    owner = "gnuwget";
    repo = pname;
    rev = version;
    sha256 = "1gws8y3z8xzi46c48n7jb162mr3ar4c34s7yy8kjcs14yzq951qz";
  };

  patches = [
    (fetchpatch {
      name = "fix-autotools-2.70.patch";
      url = "https://gitlab.com/gnuwget/wget2/-/commit/580af869093cfda6bc8a9d5901850354a16b3666.patch";
      sha256 = "1x6wq4wxvvy6174d52qrhxkcgmv366f8smxyki49zb6rs4gqhskd";
    })
    (fetchpatch {
      name = "update-potfiles-for-gnulib-2020-11-28.patch";
      url = "https://gitlab.com/gnuwget/wget2/-/commit/368deb9fcca0c281f9c76333607cc878c3945ad0.patch";
      sha256 = "1qsz8hbzbgg14wikxsbjjlq0cp3jw4pajbaz9wdn6ny617hdvi8y";
    })
  ];

  # wget2_noinstall contains forbidden reference to /build/
  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace 'bin_PROGRAMS = wget2 wget2_noinstall' 'bin_PROGRAMS = wget2'
  '';

  nativeBuildInputs = [ autoreconfHook flex lzip pkg-config python3 texinfo ];

  buildInputs = [ brotli bzip2 gpgme libhsts libidn2 libpsl xz nghttp2 pcre2 zlib zstd ]
    ++ lib.optional sslSupport openssl;

  # TODO: include translation files
  autoreconfPhase = ''
    # copy gnulib into build dir and make writable.
    # Otherwise ./bootstrap copies the non-writable files from nix store and fails to modify them
    rmdir gnulib
    cp -r ${gnulib} gnulib
    chmod -R u+w gnulib/{build-aux,lib}

    # fix bashisms can be removed when https://gitlab.com/gnuwget/wget2/-/commit/c9499dcf2f58983d03e659e2a1a7f21225141edf is in the release
    sed 's|==|=|g' -i configure.ac

    ./bootstrap --no-git --gnulib-srcdir=gnulib --skip-po
  '';

  configureFlags = [
    "--disable-static"
    # TODO: https://gitlab.com/gnuwget/wget2/-/issues/537
    (lib.withFeatureAs sslSupport "ssl" "openssl")
  ];

  outputs = [ "out" "lib" "dev" ];

  meta = with lib; {
    description = "successor of GNU Wget, a file and recursive website downloader.";
    longDescription = ''
      Designed and written from scratch it wraps around libwget, that provides the basic
      functions needed by a web client.
      Wget2 works multi-threaded and uses many features to allow fast operation.
      In many cases Wget2 downloads much faster than Wget1.x due to HTTP2, HTTP compression,
      parallel connections and use of If-Modified-Since HTTP header.
    '';
    homepage = "https://gitlab.com/gnuwget/wget2";
    # wget2 GPLv3+; libwget LGPLv3+
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
