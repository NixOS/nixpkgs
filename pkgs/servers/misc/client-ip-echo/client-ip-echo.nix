{ mkDerivation, fetchFromGitHub, base, bytestring, network, stdenv }:
mkDerivation {
  pname = "client-ip-echo";
  version = "0.1.0.3";
  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "client-ip-echo";
    rev = "8d1a79d94a962b3266c1db51200913c2295d8922";
    sha256 = "1g1s7i68n3906m3yjfygw96j64n8nh88lmf77blnz0xzrq4y3bgf";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network ];
  description = "accepts TCP connections and echoes the client's IP address back to it";
  license = stdenv.lib.licenses.lgpl3;
}
