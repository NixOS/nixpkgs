{ stdenv, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  pname = "bento4";
  version = "1.6.0-637";

  src = fetchFromGitHub {
    owner = "axiomatic-systems";
    repo = "Bento4";
    rev = "v${version}";
    sha256 = "0iwqi71nj0iczffvpxmz0prvmmnyiqypfwvzivkh38wl0br82bkp";
  };

  patches = [ ./libap4.patch ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  installPhase = ''
    mkdir -p $out/{lib,bin}
    find -iname '*.so' -exec mv --target-directory="$out/lib" {} \;
    find -maxdepth 1 -executable -type f -exec mv --target-directory="$out/bin" {} \;
  '';

  meta = with stdenv.lib; {
    description = "Full-featured MP4 format and MPEG DASH library and tools";
    homepage = "http://bento4.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ makefu ];
    broken = stdenv.isAarch64;
    platforms = platforms.linux;
  };
}
