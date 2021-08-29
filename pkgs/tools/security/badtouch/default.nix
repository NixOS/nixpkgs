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
  pname = "badtouch";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "05dzwx9y8zh0y9zd4mibp02255qphc6iqy916fkm3ahaw0rg84h3";
  };

  cargoSha256 = "0mmglgz037dk3g7qagf1dyss5hvvsdy0m5m1h6c3rk5bp5kjzg87";

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
    homepage = "https://github.com/kpcyrd/badtouch";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
