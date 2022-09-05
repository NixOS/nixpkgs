{ lib, kernel, rtl8189es, fetchFromGitHub, fetchpatch }:

# rtl8189fs is a branch of the rtl8189es driver
rtl8189es.overrideAttrs (drv: rec {
  name = "rtl8189fs-${kernel.version}-${version}";
  version = "2022-05-20";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "71500c28164369800041d1716ac513457179ce93";
    sha256 = "sha256-JTv+ssSv5toNcZ5wR6p0Cywdk87z9Bdq0ftU0ekr/98=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/jwrdegoede/rtl8189ES_linux/pull/81.patch";
      sha256 = "sha256-ovFQBIHLk3wi2uwAyr8VmdbuhPcoHsZ/lpA66obVBK4=";
    })
  ];

  meta = with lib; {
    description = "Driver for Realtek rtl8189fs";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux/tree/rtl8189fs";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
})
