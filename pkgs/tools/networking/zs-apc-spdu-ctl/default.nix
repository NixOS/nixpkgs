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
<<<<<<< HEAD
    owner = "fogti";
=======
    owner = "zseri";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = [ maintainers.fogti ];
=======
    maintainers = with maintainers; [ zseri ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
