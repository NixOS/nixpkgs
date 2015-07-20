{ stdenv, fetchurl, pam, openssl, openssh, shadow, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.14";
  name = "shellinabox-${version}";

  src = fetchurl {
    url = "https://shellinabox.googlecode.com/files/shellinabox-${version}.tar.gz";
    sha1 = "9e01f58c68cb53211b83d0f02e676e0d50deb781";
  };

  buildInputs = [ pam openssl openssh makeWrapper ];

  patches = [ ./shellinabox-minus.patch ];

  # Disable GSSAPIAuthentication errors. Also, paths in certain source files are
  # hardcoded. Replace the hardcoded paths with correct paths.
  preConfigure = ''
    substituteInPlace ./shellinabox/service.c --replace "-oGSSAPIAuthentication=no" ""
    substituteInPlace ./shellinabox/launcher.c --replace "/usr/games" "${openssh}/bin"
    substituteInPlace ./shellinabox/service.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./shellinabox/launcher.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./libhttp/ssl.c --replace "/usr/bin" "${openssl}/bin"
  '';

  postInstall = ''
    wrapProgram $out/bin/shellinaboxd \
      --prefix LD_LIBRARY_PATH : ${openssl}/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/shellinabox;
    description = "Web based AJAX terminal emulator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomberek lihop ];
    platforms = platforms.linux;
  };
}
