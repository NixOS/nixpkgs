{ stdenv, fetchurl, autoreconfHook, pkgconfig, zlib, libuuid, libossp_uuid, CoreFoundation, IOKit }:

stdenv.mkDerivation rec{
  version = "1.11.0";
  name = "netdata-${version}";

  src = fetchurl {
    url = "https://github.com/netdata/netdata/releases/download/v${version}/netdata-v${version}.tar.gz";
    sha256 = "17b14w34jif6bviw3s81imbazkvvafwxff7d5zjy6wicq88q8b64";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib ]
    ++ (if stdenv.isDarwin then [ libossp_uuid CoreFoundation IOKit ] else [ libuuid ]);

  patches = [
    ./no-files-in-etc-and-var.patch
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  postFixup = ''
    rm -r $out/sbin
  '';

  meta = with stdenv.lib; {
    description = "Real-time performance monitoring tool";
    homepage = https://my-netdata.io/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.lethalman ];
  };

}
