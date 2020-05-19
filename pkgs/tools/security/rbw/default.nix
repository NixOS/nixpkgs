{ lib
, rustPlatform
, fetchCrate
, pinentry
, openssl
, pkgconfig
, makeWrapper
, cargo

# rbw-fzf
, withFzf ? false, fzf, perl

# rbw-rofi
, withRofi ? false, rofi, xclip

# pass-import
, withPass ? false, pass
}:

rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "0.4.4";

  src = fetchCrate {
    inherit version;
    crateName = "${pname}";
    sha256 = "01p37zx2h3gpm363xn96w0wlg7kqayjl3an65h9p6md21d41bvyr";
  };

  cargoSha256 = "1xiw21snsbqxfw624cdc340asp2kmcp8rymfcjj7w2lwcqhadrh9";

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace src/pinentry.rs \
        --replace "Command::new(\"pinentry\")" "Command::new(\"${pinentry}/bin/pinentry\")"
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
    maintainers = with maintainers; [ albakham luc65r ];
    platforms = platforms.all;
  };
}
