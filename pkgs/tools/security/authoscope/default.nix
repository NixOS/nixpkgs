{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, libcap
, openssl
, pkg-config
, rustPlatform
, Security
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "authoscope";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SKgb/N249s0+Rb59moBT/MeFb4zAAElCMQJto0diyUk=";
  };

  cargoHash = "sha256-rSHuKy86iJNLAKSVcb7fn7A/cc75EOc97jGI14EaC6k=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libcap
    zlib
    openssl
  ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage docs/${pname}.1
  '';

  # Tests requires access to httpin.org
  doCheck = false;

  meta = with lib; {
    description = "Scriptable network authentication cracker";
    homepage = "https://github.com/kpcyrd/authoscope";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
