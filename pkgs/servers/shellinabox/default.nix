{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pam, openssl, openssh, shadow, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.20";
  pname = "shellinabox";

  src = fetchFromGitHub {
    owner = "shellinabox";
    repo = "shellinabox";
    rev = "v${version}";
    sha256 = "1hmfayh21cks2lyj572944ll0mmgsxbnj981b3hq3nhdg8ywzjfr";
  };

  patches = [
    ./shellinabox-minus.patch
    (fetchpatch {
      name = "CVE-2018-16789.patch";
      url = "https://github.com/shellinabox/shellinabox/commit/4f0ecc31ac6f985e0dd3f5a52cbfc0e9251f6361.patch";
      sha256 = "1mpm6acxdb0fms9pa2b88fx6hp07ph87ahxi82yyqj2m7p79jx7a";
    })
  ];

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ pam openssl openssh ];

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
    homepage = https://github.com/shellinabox/shellinabox;
    description = "Web based AJAX terminal emulator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomberek lihop ];
    platforms = platforms.linux;
  };
}
