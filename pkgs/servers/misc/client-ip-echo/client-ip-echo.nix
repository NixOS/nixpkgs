{ mkDerivation, fetchFromGitHub, base, bytestring, network, lib }:
mkDerivation {
  pname = "client-ip-echo";
  version = "0.1.0.5";
  src = fetchFromGitHub {
    owner = "jerith666";
    repo = "client-ip-echo";
    rev = "e81db98d04c13966b2ec114e01f82487962055a7";
    sha256 = "02rzzbm1mdqh5zx5igd0s7pwkcsk64lx40rclxw3485348brc6ya";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network ];
  description = "accepts TCP connections and echoes the client's IP address back to it";
  license = lib.licenses.lgpl3;
  mainProgram = "client-ip-echo";
}
