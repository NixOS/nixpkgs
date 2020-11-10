{ stdenv
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
, clang
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "1v5gxcz4zbc673i5kbsnjq8bikf7jdbn3wjfz1wppjrgwnkgvsh9";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config clang ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib"
  '';

  cargoSha256 = "19drjql13z8bw257z10kjppxm25jlfgrpc9g1jf68ka5j2b3nx7k";

  meta = with stdenv.lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
