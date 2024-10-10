{ lib, stdenv, fetchurl, fetchpatch, openssl, pcre, libidn, zlib }:

stdenv.mkDerivation rec {
  pname = "skipfish";
  version = "2.10b";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/skipfish/skipfish-${version}.tgz";
    sha256 = "17ia6p2q4v6j9achq47lnwkn29j3v4l75sj616brn7rz06fvqkqs";
  };

  patches = [
    # Provide absolute store paths to data files
    ./absolute-paths.patch

    # Fix compilation for modern openssl
    # https://gitlab.com/kalilinux/packages/skipfish/-/blob/903a0457ee029d3401c515120efae6fe0dcddfa1/debian/patches/Fix-for-openssl-1.1.patch
    (fetchpatch {
      url = "https://gitlab.com/kalilinux/packages/skipfish/-/raw/903a0457ee029d3401c515120efae6fe0dcddfa1/debian/patches/Fix-for-openssl-1.1.patch";
      sha256 = "0cgx7qnfyrf6sc3b6186nrqmssqcl7kf33xblxgmcipzr073r6r2";
    })
    # https://gitlab.com/kalilinux/packages/skipfish/-/blob/903a0457ee029d3401c515120efae6fe0dcddfa1/debian/patches/Fix-broken-ciphersuite-evaluation-for-newer-OpenSSLs.patch
    (fetchpatch {
      url = "https://gitlab.com/kalilinux/packages/skipfish/-/raw/903a0457ee029d3401c515120efae6fe0dcddfa1/debian/patches/Fix-broken-ciphersuite-evaluation-for-newer-OpenSSLs.patch";
      sha256 = "1jqj31v8iw638jgs38l1gmh8iyml8bp2fjcn4yips6dq49vgndf1";
    })
  ];

  postPatch = ''
    substituteAllInPlace src/config.h
    substituteAllInPlace signatures/signatures.conf
    substituteInPlace signatures/signatures.conf \
      --replace "include signatures" "include $out/share/skipfish/signatures"
  '';

  buildInputs = [
    openssl
    pcre
    libidn
    zlib
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    install -Dm755 skipfish $out/bin/skipfish
    install -Dm755 tools/sfscandiff $out/bin/sfscandiff
    mkdir -p $out/share/skipfish
    cp -r assets doc signatures config $out/share/skipfish
  '';

  meta = with lib; {
    description = "Fully automated, active web application security reconnaissance tool";
    homepage = "https://code.google.com/archive/p/skipfish/";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
