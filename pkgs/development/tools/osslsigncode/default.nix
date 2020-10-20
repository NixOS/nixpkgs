{ stdenv
, fetchFromGitHub
, autoreconfHook
, libgsf
, pkgconfig
, openssl
, curl
}:

stdenv.mkDerivation rec {
  pname = "osslsigncode-unstable";
  version = "2020-08-02";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = "osslsigncode";
    rev = "01b3fb5b542ed0b41e3860aeee7a85b735491ff2";
    sha256 = "03ynm1ycbi86blglma3xiwadck8kc5yb0gawjzlhyv90jidn680l";
  };

  nativeBuildInputs = [ autoreconfHook libgsf pkgconfig openssl curl ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.all;
  };
}
