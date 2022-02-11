{ lib
, fetchurl
, installShellFiles
, libsodium
, pkg-config
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ratman";
  version = "0.3.1";

  src = fetchurl {
    url = "https://git.irde.st/we/irdest/-/archive/${pname}-${version}/irdest-${pname}-${version}.tar.gz";
    sha256 = "0x1wvhsmf7m55j9hmirkz75qivsg33xab1sil6nbv8fby428fpq6";
  };

  cargoSha256 = "1dkfyy1z34qaavyd3f20hrrrb3kjsdfkyzd535xlds9wivgchmd0";

  nativeBuildInputs = [ protobuf pkg-config installShellFiles ];

  cargoBuildFlags = [ "--all-features" "-p" "ratman" ];
  cargoTestFlags = cargoBuildFlags;

  buildInputs = [ libsodium ];

  postInstall = ''
    installManPage docs/man/ratmand.1
  '';

  SODIUM_USE_PKG_CONFIG = 1;

  meta = with lib; {
    description = "A modular decentralised peer-to-peer packet router and associated tools";
    homepage = "https://git.irde.st/we/irdest";
    platforms = platforms.unix;
    license = licenses.agpl3;
    maintainers = with maintainers; [ spacekookie yuka ];
  };
}
