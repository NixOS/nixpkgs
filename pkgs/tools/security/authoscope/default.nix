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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ci38m6d3lj4f0g7cl3dqf10kfk258k2k92phd2nav1my4i90pf";
  };

  cargoSha256 = "13x7i52i3k88vkfvk2smy2aqfg3na4317scvw7ali1rv545nbxds";

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
