{ stdenv, callPackage, fetchFromGitHub, autoreconfHook, pkgconfig
, CoreFoundation, IOKit, libossp_uuid
, curl, libcap,  libuuid, lm_sensors, zlib, fetchpatch
, withCups ? false, cups
, withDBengine ? true, libuv, lz4, judy
, withIpmi ? (!stdenv.isDarwin), freeipmi
, withNetfilter ? (!stdenv.isDarwin), libmnl, libnetfilter_acct
, withSsl ? true, openssl
, withDebug ? false
}:

with stdenv.lib;

let
  go-d-plugin = callPackage ./go.d.plugin.nix {};
in stdenv.mkDerivation rec {
  version = "1.20.0";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${version}";
    sha256 = "0g7iv5w14wndl5iv2q81dppgwq09sm93vpnyq7p49nl7q1dsz1d6";
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
    # part of the next release
    (fetchpatch {
      url = "https://github.com/netdata/netdata/commit/5c992b7d92cf008ce91627efccf8644732db1f87.patch";
      sha256 = "1nvbmhy5rir4kw77dhx1qr0l0wcspakr7z7ivva1ilz1aml8nbnm";
    })
  ];

  NIX_CFLAGS_COMPILE = optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall = ''
    ln -s ${go-d-plugin.bin}/lib/netdata/conf.d/* $out/lib/netdata/conf.d
    ln -s ${go-d-plugin.bin}/bin/godplugind $out/libexec/netdata/plugins.d/go.d.plugin
  '' + optionalString (!stdenv.isDarwin) ''
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
