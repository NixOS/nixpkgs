{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig
, bind, zlib, openssl, libcap
}:

stdenv.mkDerivation rec {
  pname = "dnsperf";
  version = "2.3.1";

  # The same as the initial commit of the new GitHub repo (only readme changed).
  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    sha256 = "0yxwm5xi9ry154ayzn2h27bnwwc202bsna8h6i4a65pn76nrn81w";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ bind zlib openssl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libcap.lib ];

  # For now, keep including the old PDFs as well.
  # https://github.com/DNS-OARC/dnsperf/issues/27
  postInstall = let
    src-doc = fetchurl {
      url = "ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/"
          + "dnsperf-src-2.1.0.0-1.tar.gz";
      sha256 = "03kfc65s5a9csa5i7xjsv0psq144k8d9yw7xlny61bg1h2kg1db4";
    };
  in ''
    tar xf '${src-doc}'
    cp ./dnsperf-src-*/doc/*.pdf "$doc/share/doc/dnsperf/"
  '';

  meta = with stdenv.lib; {
    outputsToInstall = outputs; # The man pages and docs are likely useful to most.

    description = "Tools for DNS benchmaring";
    homepage = "https://github.com/DNS-OARC/dnsperf";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
