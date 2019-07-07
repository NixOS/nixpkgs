{ mkDerivation, fetchFromGitHub, base, bytestring, network, stdenv }:
mkDerivation {
  pname = "client-ip-echo";
  version = "0.1.0.4";
  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "client-ip-echo";
    rev = "58d1bc627c21008236afb1af4c09ba8153c95dad";
    sha256 = "153fab87qq080a819bqbdan925045icqwxldwj3ps40w2ssn7a53";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network ];
  description = "accepts TCP connections and echoes the client's IP address back to it";
  license = stdenv.lib.licenses.lgpl3;
}
