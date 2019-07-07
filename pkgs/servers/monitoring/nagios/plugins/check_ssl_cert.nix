{ stdenv, fetchFromGitHub, file, openssl, makeWrapper, which, curl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "check_ssl_cert-${version}";
  version = "1.80.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "v${version}";
    sha256 = "1jkwii45hynil1jail9gmz4bak066rdi8zfcczicjsa6npbz50w4";
  };

  patches = [
    # https://github.com/matteocorti/check_ssl_cert/pull/114
    (fetchpatch {
      url = "https://github.com/matteocorti/check_ssl_cert/commit/2b7aad583d507a70605dd44d918739a65b267bfd.patch";
      sha256 = "1jk872jgm6k3qc1ks1h3v6p804spjlnxcj2wc8v0hkmwfwiwd2k4";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "DESTDIR=$(out)/bin" "MANDIR=$(out)/share/man" ];

  postInstall = ''
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${stdenv.lib.makeBinPath [ openssl file which curl ]}"
  '';

  meta = with stdenv.lib; {
    description = "A Nagios plugin to check the CA and validity of an X.509 certificate";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
