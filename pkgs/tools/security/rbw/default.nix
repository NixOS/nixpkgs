{ lib
, stdenv
, rustPlatform
, fetchCrate
, pinentry
, openssl
, pkgconfig
, makeWrapper
, Security

# rbw-fzf
, withFzf ? false, fzf, perl

# rbw-rofi
, withRofi ? false, rofi, xclip

# pass-import
, withPass ? false, pass
}:

rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "0.5.0";

  src = fetchCrate {
    inherit version;
    crateName = pname;
    sha256 = "0p37kwkp153mkns4bh7k7gnksk6c31214wlw3faf42daav32mmgw";
  };

  cargoSha256 = "1vkgh0995xx0hr96mnzmdgd15gs6da7ynywqcjgcw5kr48bf1063";

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postPatch = ''
    substituteInPlace src/pinentry.rs \
      --replace 'Command::new("pinentry")' 'Command::new("${pinentry}/${pinentry.binaryPath or "bin/pinentry"}")'
  '' + lib.optionalString withFzf ''
    patchShebangs bin/rbw-fzf
    substituteInPlace bin/rbw-fzf \
        --replace fzf ${fzf}/bin/fzf \
        --replace perl ${perl}/bin/perl
  '' + lib.optionalString withRofi ''
    patchShebangs bin/rbw-rofi
    substituteInPlace bin/rbw-rofi \
        --replace rofi ${rofi}/bin/rofi \
        --replace xclip ${xclip}/bin/xclip
  '' + lib.optionalString withRofi ''
    patchShebangs bin/pass-import
    substituteInPlace bin/pass-import \
        --replace pass ${pass}/bin/pass
  '';

  preConfigure = ''
    export OPENSSL_INCLUDE_DIR="${openssl.dev}/include"
    export OPENSSL_LIB_DIR="${openssl.out}/lib"
  '';

  postInstall = lib.optionalString withFzf ''
    cp bin/rbw-fzf $out/bin
  '' + lib.optionalString withRofi ''
    cp bin/rbw-rofi $out/bin
  '' + lib.optionalString withPass ''
    cp bin/pass-import $out/bin
  '';

  meta = with lib; {
    description = "Unofficial command line client for Bitwarden";
    homepage = "https://crates.io/crates/rbw";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham luc65r marsam ];
  };
}
