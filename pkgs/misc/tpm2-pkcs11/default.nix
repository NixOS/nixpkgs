{ stdenv, lib, fetchFromGitHub, substituteAll
, pkg-config, autoreconfHook, autoconf-archive, makeWrapper, patchelf
, tpm2-tss, tpm2-tools, opensc, openssl, sqlite, python3, glibc, libyaml
, abrmdSupport ? true, tpm2-abrmd ? null
, fapiSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "tpm2-pkcs11";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
    sha256 = "sha256-SoHtgZRIYNJg4/w1MIocZAM26mkrM+UOQ+RKCh6nwCk=";
  };

  patches = [
    ./version.patch
    ./graceful-fapi-fail.patch
  ];

  # The preConfigure phase doesn't seem to be working here
  # ./bootstrap MUST be executed as the first step, before all
  # of the autoreconfHook stuff
  postPatch = ''
    echo ${version} > VERSION
    ./bootstrap
  '';

  configureFlags = lib.optionals (!fapiSupport) [
    # Note: this will be renamed to with-fapi in next release.
    "--enable-fapi=no"
  ];

  nativeBuildInputs = [
    pkg-config autoreconfHook autoconf-archive makeWrapper patchelf
  ];
  buildInputs = [
    tpm2-tss tpm2-tools opensc openssl sqlite libyaml
    (python3.withPackages (ps: with ps; [ packaging pyyaml cryptography pyasn1-modules tpm2-pytss ]))
  ];

  outputs = [ "out" "bin" "dev" ];

  dontStrip = true;
  dontPatchELF = true;

  # To be able to use the userspace resource manager, the RUNPATH must
  # explicitly include the tpm2-abrmd shared libraries.
  preFixup = let
    rpath = lib.makeLibraryPath (
      (lib.optional abrmdSupport tpm2-abrmd)
      ++ [
        tpm2-tss
        sqlite
        openssl
        glibc
        libyaml
      ]
    );
  in ''
    patchelf \
      --set-rpath ${rpath} \
      ${lib.optionalString abrmdSupport "--add-needed ${lib.makeLibraryPath [tpm2-abrmd]}/libtss2-tcti-tabrmd.so"} \
      --add-needed ${lib.makeLibraryPath [tpm2-tss]}/libtss2-tcti-device.so \
      $out/lib/libtpm2_pkcs11.so.0.0.0
  '';

  postInstall = ''
    mkdir -p $bin/bin/ $bin/share/tpm2_pkcs11/
    mv ./tools/* $bin/share/tpm2_pkcs11/
    makeWrapper $bin/share/tpm2_pkcs11/tpm2_ptool.py $bin/bin/tpm2_ptool \
      --prefix PATH : ${lib.makeBinPath [ tpm2-tools ]}
  '';

  meta = with lib; {
    description = "A PKCS#11 interface for TPM2 hardware";
    homepage = "https://github.com/tpm2-software/tpm2-pkcs11";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "tpm2_ptool";
  };
}
