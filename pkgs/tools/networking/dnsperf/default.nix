{ stdenv, fetchurl, bind, libseccomp, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "dnsperf-${version}";
  version = "2.1.0.0";

  src = fetchurl {
    url = "ftp://ftp.nominum.com/pub/nominum/dnsperf/${version}/"
        + "dnsperf-src-${version}-1.tar.gz";
    sha256 = "03kfc65s5a9csa5i7xjsv0psq144k8d9yw7xlny61bg1h2kg1db4";
  };

  outputs = [ "out" "man" "doc" ];

  buildInputs = [ bind libseccomp zlib openssl ];

  postInstall = ''
    mkdir -p "$out/share/doc/"
    cp -r ./doc "$out/share/doc/dnsperf"
  '';

  meta = with stdenv.lib; {
    outputsToInstall = outputs; # The man pages and PDFs are likely useful to most.

    description = "Tools for DNS benchmaring";
    homepage = https://nominum.com/measurement-tools/;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}

