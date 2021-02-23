{ stdenv, lib, fetchFromGitHub, autoreconfHook, perl, openssl, pcre, zlib }:

stdenv.mkDerivation rec {
  pname = "trafficserver";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = pname;
    rev = version;
    sha256 = "sha256-PmfgZGs0A5A21UpShPsBpzZULZPJYnbyeJLNuPgmeh8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    openssl.dev
    pcre.dev
    zlib.dev
  ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-pcre=${pcre.dev}"
    "--with-experimental-plugins"
  ];

  meta = with lib; {
    homepage = "https://trafficserver.apache.org";
    # Refers to a non-existant 10.0 and isn't very changelog-ie
    # changelog = "https://docs.trafficserver.apache.org/en/latest/release-notes/index.en.html";
    # Should exist according to previous releases (8 & 7) but hasn't been commited
    # changelog = "https://github.com/apache/trafficserver/blob/${version}/CHANGELOG-${version}";
    description = "A fast, scalable and extensible HTTP/1.1 and HTTP/2 compliant caching proxy server";
    longDescription = ''
      Traffic Server is a high-performance building block for cloud services.
      It's more than just a caching proxy server; it also has support for
      plugins to build large scale web applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ "joaquinito2051" ];
    platforms = platforms.all;
  };
}
