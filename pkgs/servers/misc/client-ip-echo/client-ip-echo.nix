{ mkDerivation, fetchFromGitHub, base, bytestring, network, stdenv }:
mkDerivation {
  pname = "client-ip-echo";
  version = "0.1.0.1";
  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "client-ip-echo";
    rev = "f6e3e115a1e61a387cf79956ead36d7ac25a2901";
    sha256 = "0irxcaiwxxn4ggd2dbya1mvpnyfanx0x06whp8ccrha141cafwqp";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network ];
  description = "accepts TCP connections and echoes the client's IP address back to it";
  license = stdenv.lib.licenses.lgpl3;
  broken = true; # 2018-04-10
}
