{ stdenv, lib, fetchgit, cmake, openssl, boost, zlib, rippled }:

stdenv.mkDerivation rec {
  name = "rippled-validator-keys-tool-20180927-${builtins.substring 0 7 rev}";
  rev = "d7774bcc1dc9439c586ea1c175fcd5ff3960b15f";

  src = fetchgit {
    url = "https://github.com/ripple/validator-keys-tool.git";
    inherit rev;
    sha256 = "1hcbwwa21n692qpbm0vqy5jvvnf4aias309610m4kwdsnzfw0902";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl boost zlib rippled ];

  hardeningDisable = ["format"];

  preConfigure = ''
    export CXX="$(command -v $CXX)"
    export CC="$(command -v $CC)"
  '';

  installPhase = ''
    install -D validator-keys $out/bin/validator-keys
  '';

  meta = with lib; {
    broken = true;
    description = "Generate master and ephemeral rippled validator keys";
    homepage = "https://github.com/ripple/validator-keys-tool";
    maintainers = with maintainers; [ offline ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
