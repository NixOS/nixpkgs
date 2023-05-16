{ lib
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
<<<<<<< HEAD
=======
, clang
, llvmPackages
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "sha256-bXwaFiRHURvS5KtTqIj+3GlGNbEulDgMDP51ZiO1w9o=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ cryptsetup ];

=======
  nativeBuildInputs = [ pkg-config clang ];

  buildInputs = [ cryptsetup ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cargoSha256 = "sha256-MPji87jYJjYtDAXO+v/Z4XRtCKo+ftsNvmlBrM9iMTk=";

  meta = with lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.mpl20;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
