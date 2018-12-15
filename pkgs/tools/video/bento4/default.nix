{ stdenv, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  name = "bento4-${version}";
  version = "1.5.1-624";

  src = fetchFromGitHub {
    owner = "axiomatic-systems";
    repo = "Bento4";
    rev = "v${version}";
    sha256 = "1cq6vhrq3n3lc1n454slbc66qdyqam2srxgdhfpyfxbq5c4y06nf";
  };

  nativeBuildInputs = [ cmake ];
  installPhase = ''
    mkdir -p $out/{lib,bin}
    find -iname '*.so' -exec mv --target-directory="$out/lib" {} \;
    find -maxdepth 1 -executable -type f -exec mv --target-directory="$out/bin" {} \;
  '';

  meta = with stdenv.lib; {
    description = "Full-featured MP4 format and MPEG DASH library and tools";
    homepage = http://bento4.com;
    license = licenses.gpl3;
    maintainers = with maintainers; [ makefu ];
    broken = stdenv.isAarch64;
    platforms = platforms.linux;
  };
}
