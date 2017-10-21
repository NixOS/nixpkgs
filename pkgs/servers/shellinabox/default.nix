{ stdenv, fetchFromGitHub, autoreconfHook, pam, openssl, openssh, shadow, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.20";
  name = "shellinabox-${version}";

  src = fetchFromGitHub {
    owner = "shellinabox";
    repo = "shellinabox";
    rev = "v${version}";
    sha256 = "1hmfayh21cks2lyj572944ll0mmgsxbnj981b3hq3nhdg8ywzjfr";
  };

  patches = [ ./shellinabox-minus.patch ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam openssl openssh makeWrapper ];

  # Disable GSSAPIAuthentication errors. Also, paths in certain source files are
  # hardcoded. Replace the hardcoded paths with correct paths.
  preConfigure = ''
    substituteInPlace ./shellinabox/service.c --replace "-oGSSAPIAuthentication=no" ""
    substituteInPlace ./shellinabox/launcher.c --replace "/usr/games" "${openssh}/bin"
    substituteInPlace ./shellinabox/service.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./shellinabox/launcher.c --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace ./libhttp/ssl.c --replace "/usr/bin" "${openssl.bin}/bin"
  '';

  postInstall = ''
    wrapProgram $out/bin/shellinaboxd \
      --prefix LD_LIBRARY_PATH : ${openssl.out}/lib
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
