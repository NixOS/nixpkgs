{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pam, openssl, openssh, shadow, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.16";
  name = "shellinabox-${version}";

  src = fetchFromGitHub {
    owner = "shellinabox";
    repo = "shellinabox";
    rev = "8ac3a4efcf20f7b66d3f1eb1d4f3054aef6e196b";
    sha256 = "1pp6nk0279d2q7l1cvx8jc73skfjv0s42wxb2m00x0bg9i1fvs5j";
  };

  patches = [ ./shellinabox-minus.patch ];

  buildInputs = [ autoconf automake libtool pam openssl openssh makeWrapper];

  # Disable GSSAPIAuthentication errors. Also, paths in certain source files are
  # hardcoded. Replace the hardcoded paths with correct paths.
  preConfigure = ''
    substituteInPlace ./shellinabox/service.c --replace "-oGSSAPIAuthentication=no" ""
    substituteInPlace ./shellinabox/launcher.c --replace "/usr/games" "${openssh}/bin"
    substituteInPlace ./shellinabox/service.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./shellinabox/launcher.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./libhttp/ssl.c --replace "/usr/bin" "${openssl}/bin"
    autoreconf -vfi
  '';

  postInstall = ''
    wrapProgram $out/bin/shellinaboxd \
      --prefix LD_LIBRARY_PATH : ${openssl}/lib
    mkdir -p $out/lib
    cp shellinabox/* $out/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/shellinabox;
    description = "Web based AJAX terminal emulator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomberek lihop ];
    platforms = platforms.linux;
  };
}
