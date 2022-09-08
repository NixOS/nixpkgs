{ lib
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
, clang
, llvmPackages
, fetchpatch
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

  cargoPatches = [
    #https://github.com/shimunn/fido2luks/pull/50
    (fetchpatch {
      name = "libcryptsetup-rs.patch";
      url = "https://github.com/shimunn/fido2luks/commit/c87a9bbb4cbbe90be7385d4bc2946716c593b91d.diff";
      sha256 = "2IWz9gcEbXhHlz7VWoJNBZfwnJm/J3RRuXg91xH9Pl4=";
    })
  ];

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config clang ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

  cargoSha256 = "U/2dAmFmW6rQvojaKSDdO+/WzajBJmhOZWvzwdiYBm0=";

  meta = with lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
