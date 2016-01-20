{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "chntpw-${version}";

  version = "140201";

  src = fetchurl {
    url = "http://pogostick.net/~pnh/ntpasswd/chntpw-source-${version}.zip";
    sha256 = "1k1cxsj0221dpsqi5yibq2hr7n8xywnicl8yyaicn91y8h2hkqln";
  };

  buildInputs = [ unzip ]
    ++ stdenv.lib.optionals stdenv.isLinux [ stdenv.glibc.out stdenv.glibc.static ];

  patches = [
    ./00-chntpw-build-arch-autodetect.patch
    ./01-chntpw-install-target.patch
  ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://pogostick.net/~pnh/ntpasswd/;
    description = "An utility to reset the password of any user that has a valid local account on a Windows system";
    maintainers = with stdenv.lib.maintainers; [ deepfire ];
    license = licenses.gpl2;
  };
}
