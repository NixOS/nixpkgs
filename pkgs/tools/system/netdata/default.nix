{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, CoreFoundation, IOKit, libossp_uuid
, curl, libcap,  libuuid, lm_sensors, zlib
, withCups ? false, cups
, withDBengine ? true, libuv, lz4, judy
, withIpmi ? (!stdenv.isDarwin), freeipmi
, withNetfilter ? (!stdenv.isDarwin), libmnl, libnetfilter_acct
, withSsl ? true, openssl
, withDebug ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.19.0";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${version}";
    sha256 = "1s6kzx4xh8b6v7ki8h2mfzprj5rxvlgx2md20cr8c0v81qpz3q3q";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ curl.dev zlib.dev ]
    ++ optionals stdenv.isDarwin [ CoreFoundation IOKit libossp_uuid ]
    ++ optionals (!stdenv.isDarwin) [ libcap.dev libuuid.dev ]
    ++ optionals withCups [ cups ]
    ++ optionals withDBengine [ libuv lz4.dev judy ]
    ++ optionals withIpmi [ freeipmi ]
    ++ optionals withNetfilter [ libmnl libnetfilter_acct ]
    ++ optionals withSsl [ openssl.dev ];

  patches = [
    ./no-files-in-etc-and-var.patch
  ];

  NIX_CFLAGS_COMPILE = optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall = optionalString (!stdenv.isDarwin) ''
    # rename this plugin so netdata will look for setuid wrapper
    mv $out/libexec/netdata/plugins.d/apps.plugin \
       $out/libexec/netdata/plugins.d/apps.plugin.org
    ${optionalString withIpmi ''
      mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
         $out/libexec/netdata/plugins.d/freeipmi.plugin.org
    ''}
  '';

  preConfigure =  optionalString (!stdenv.isDarwin) ''
    substituteInPlace collectors/python.d.plugin/python_modules/third_party/lm_sensors.py \
      --replace 'ctypes.util.find_library("sensors")' '"${lm_sensors.out}/lib/libsensors${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  postFixup = ''
    rm -r $out/sbin
  '';

  meta = {
    description = "Real-time performance monitoring tool";
    homepage = https://my-netdata.io/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.lethalman ];
  };

}
