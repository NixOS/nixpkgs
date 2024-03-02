{ stdenv, lib, fetchFromGitHub, cmake, openssl, boost, zlib, icu, rippled }:

stdenv.mkDerivation rec {
  pname = "rippled-validator-keys-tool";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "validator-keys-tool";
    rev = "5d7efcfeda3bdf6f5dda78056004a7c326321e9b";
    sha256 = "1irm8asp6plk9xw3ksf4fqnim8h0vj3h96w638lx71pga1h4zvmy";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl boost zlib icu rippled ];

  hardeningDisable = ["format"];

  cmakeFlags = [
    "-Dep_procs=1"
  ];

  installPhase = ''
    runHook preInstall
    install -D validator-keys $out/bin/validator-keys
    runHook postInstall
  '';

  meta = with lib; {
    description = "Generate master and ephemeral rippled validator keys";
    homepage = "https://github.com/ripple/validator-keys-tool";
    maintainers = with maintainers; [ offline rmcgibbo ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
