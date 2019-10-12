{ stdenv
, fetchFromGitHub
, autoreconfHook
, libgsf
, pkgconfig
, openssl
, curl
}:

stdenv.mkDerivation rec {
  pname = "osslsigncode";
  version = "unstable-2019-07-25";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = pname;
    rev = "18810b7e0bb1d8e0d25b6c2565a065cf66bce5d7";
    sha256 = "02jnbr3xdsb5dpll3k65080ryrfr7agawmjavwxd0v40w0an5yq8";
  };

  nativeBuildInputs = [ autoreconfHook libgsf pkgconfig openssl curl ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}

