{ stdenv, lib, fetchurl, guile, pkg-config, guile-fibers }:

stdenv.mkDerivation rec {
  pname = "gnu-shepherd";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://gnu/shepherd/shepherd-${version}.tar.gz";
    sha256 = "0qy2yq13xhf05an5ilz7grighdxicx56211yaarqq5qigiiybc32";
  };

  configureFlags = [ "--localstatedir=/" ];

  buildInputs = [ guile guile-fibers ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kloenk ];
  };
}
