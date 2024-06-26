{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "catdoc";
  version = "0.95";

  src = fetchurl {
    url = "http://ftp.wagner.pp.ru/pub/catdoc/${pname}-${version}.tar.gz";
    sha256 = "514a84180352b6bf367c1d2499819dfa82b60d8c45777432fa643a5ed7d80796";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdoc/1:0.95-4.1/debian/patches/05-CVE-2017-11110.patch";
      sha256 = "1ljnwvssvzig94hwx8843b88p252ww2lbxh8zybcwr3kwwlcymx7";
    })
  ];

  # Remove INSTALL file to avoid `make` misinterpreting it as an up-to-date
  # target on case-insensitive filesystems e.g. Darwin
  preInstall = ''
    rm -v INSTALL
  '';

  configureFlags = [ "--disable-wordview" ];

  meta = with lib; {
    description = "MS-Word/Excel/PowerPoint to text converter";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
