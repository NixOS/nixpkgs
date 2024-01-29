{ cmake
, fetchFromGitHub
, fping
, lib
, libowlevelzs
, net-snmp
, stdenv
}:

# TODO: add a services entry for the /etc/zs-apc-spdu.conf file
stdenv.mkDerivation rec {
  pname = "zs-apc-spdu-ctl";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "fogti";
    repo = "zs-apc-spdu-ctl";
    rev = "v${version}";
    sha256 = "TMV9ETWBVeXq6tZ2e0CrvHBXoyKfOLCQurjBdf/iw/M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libowlevelzs net-snmp ];

  postPatch = ''
    substituteInPlace src/confent.cxx \
      --replace /usr/sbin/fping "${fping}/bin/fping"
  '';

  meta = with lib; {
    description = "APC SPDU control utility";
    license = licenses.mit;
    maintainers = [ maintainers.fogti ];
    platforms = platforms.linux;
  };
}
