{ stdenv, fetchurl, bind, libseccomp, zlib, openssl, libcap }:

stdenv.mkDerivation rec {
  name = "dnsperf-${version}";
  version = "2.1.0.0";

  # The same as the initial commit of the new GitHub repo (only readme changed).
  src = fetchurl {
    url = "ftp://ftp.nominum.com/pub/nominum/dnsperf/${version}/"
        + "dnsperf-src-${version}-1.tar.gz";
    sha256 = "03kfc65s5a9csa5i7xjsv0psq144k8d9yw7xlny61bg1h2kg1db4";
  };

  # Almost the same as https://github.com/DNS-OARC/dnsperf/pull/12
  postPatch = ''
    find . -name '*.h' -o -name '*.c' | xargs sed \
      -e 's/\<isc_boolean_t\>/bool/g' -e 's/\<ISC_TRUE\>/true/g' -e 's/\<ISC_FALSE\>/false/g' \
      -e 's/\<isc_uint/uint/g' -e 's/\<ISC_UINT/UINT/g' -e 's/\<isc_int/int/g' \
      -e 's/\<ISC_PRINT_QUADFORMAT\>/PRIu64/g' -e 's/\<ISC_TF\>//g' \
      -i --
  '';

  outputs = [ "out" "man" "doc" ];

  buildInputs = [ bind zlib openssl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libcap.lib ];

  postInstall = ''
    mkdir -p "$out/share/doc/"
    cp -r ./doc "$out/share/doc/dnsperf"
  '';

  meta = with stdenv.lib; {
    outputsToInstall = outputs; # The man pages and PDFs are likely useful to most.

    description = "Tools for DNS benchmaring";
    homepage = "https://github.com/DNS-OARC/dnsperf";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
