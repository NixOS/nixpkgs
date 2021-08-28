{ lib
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
, clang
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "sha256-WOdbdJAcMZHSnf7AkGnEumjaDut9J8VwSJYjqLUtPXs=";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config clang ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

  cargoSha256 = "sha256-d6t/bvHpnH4lKv78tp/8DC/VrQBnaiZhnf8GrlcYhJw=";

  meta = with lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
