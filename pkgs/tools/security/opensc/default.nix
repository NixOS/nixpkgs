{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt, fetchpatch
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon, PCSC, buildPackages
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation rec {
  pname = "opensc";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "10575gb9l38cskq7swyjp0907wlziyxg4ppq33ndz319dsx69d87";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-6502.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/0d7967549751b7032f22b437106b41444aff0ba9.patch";
      sha256 = "1y42lmz8i9w99hgpakdncnv8f94cqjfabz0v4xg6wfz9akl3ff7d";
    })
    (fetchpatch {
      name = "CVE-2019-15945.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/412a6142c27a5973c61ba540e33cdc22d5608e68.patch";
      sha256 = "088i2i1fkvdxnywmb54bn4283vhbxx6i2632b34ss5dh7k080hp7";
    })
    (fetchpatch {
      name = "CVE-2019-15946.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/a3fc7693f3a035a8a7921cffb98432944bb42740.patch";
      sha256 = "1qr9n8cbarrdn4kr5z0ys7flq50hfmcbm8584mhw7r39p08qwmvq";
    })
    (fetchpatch {
      name = "CVE-2019-19479.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/c3f23b836e5a1766c36617fe1da30d22f7b63de2.patch";
      sha256 = "0xj6c6wycwynxrn3f8kziwz99z8rjwkrsnk8f0ffx7fj4d97krfw";
    })
    # needed for CVE-2019-19480.patch
    (fetchpatch {
      name = "opensc-memory-leak-fix.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/630d6adf32cecaab0ee184618f56497bd50400fb.patch";
      sha256 = "0cb6fx9pjf7z9zdi2kk1b3zz537xb7dclaqn8z0gy48xg59biwy0";
    })
    (fetchpatch {
      name = "CVE-2019-19480.patch";
      url = "https://github.com/OpenSC/OpenSC/commit/6ce6152284c47ba9b1d4fe8ff9d2e6a3f5ee02c7.patch";
      sha256 = "0xm6gl11b4nr436a8al0k8myq6i2xpc9mc24nwf4fhwj3wbzp3dq";
    })

    # CVE-2019-19481 is on applicable to 0.19
    # cac1 support was only added after it:
    # https://github.com/OpenSC/OpenSC/commit/e2b1fb81e0e1339eebaa36fb90635e03f69d4da3#diff-6d5e82180f0ee8125f09f8bedb5cd1cb
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    zlib readline openssl libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ]
  ++ stdenv.lib.optional stdenv.isDarwin Carbon
  ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  NIX_CFLAGS_COMPILE = "-Wno-error";

  configureFlags = [
    "--enable-zlib"
    "--enable-readline"
    "--enable-openssl"
    "--enable-pcsc"
    "--enable-sm"
    "--enable-man"
    "--enable-doc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-xsl-stylesheetsdir=${docbook_xsl}/xml/xsl/docbook"
    "--with-pcsc-provider=${
      if withApplePCSC then
        "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
      else
        "${stdenv.lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
      }"
    (stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform)
      "XSLTPROC=${buildPackages.libxslt}/bin/xsltproc")
  ];

  PCSC_CFLAGS = stdenv.lib.optionalString withApplePCSC
    "-I${PCSC}/Library/Frameworks/PCSC.framework/Headers";

  installFlags = [
    "sysconfdir=$(out)/etc"
    "completiondir=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = https://github.com/OpenSC/OpenSC/wiki;
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.erictapen ];
  };
}
