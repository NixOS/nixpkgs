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
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "04gl7wn38f42mapmkf026rya668vvhm03yi8iqnz31xgggbr2irm";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config clang ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

  cargoSha256 = "1sp52zsj0s3736zih71plnk01si24jsawnx0580qfgg322d5f601";

  meta = with lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
