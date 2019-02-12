{ stdenv, fetchurl, autoreconfHook, pkgconfig, zlib, libuuid, libossp_uuid, CoreFoundation, IOKit }:

stdenv.mkDerivation rec{
  version = "1.11.1";
  name = "netdata-${version}";

  src = fetchurl {
    url = "https://github.com/netdata/netdata/releases/download/v${version}/netdata-v${version}.tar.gz";
    sha256 = "0djph4586cc14vavj6za6k255lscf3b415dx8k45q3nsc2hb4l01";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib ]
    ++ (if stdenv.isDarwin then [ libossp_uuid CoreFoundation IOKit ] else [ libuuid ]);

  patches = [
    ./no-files-in-etc-and-var.patch
  ];

  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # rename this plugin so netdata will look for setuid wrapper
    mv $out/libexec/netdata/plugins.d/apps.plugin \
      $out/libexec/netdata/plugins.d/apps.plugin.org
  '';

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
