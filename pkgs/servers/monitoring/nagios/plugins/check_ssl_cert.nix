{ stdenv, fetchFromGitHub, file, openssl, makeWrapper, which, curl }:

stdenv.mkDerivation rec {
  name = "check_ssl_cert-${version}";
  version = "1.64.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "v${version}";
    sha256 = "0pq297sbz9hzcaccnnsfmra0bac81cki9xfrnb22a1hgfhqjxy5r";
  };

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
