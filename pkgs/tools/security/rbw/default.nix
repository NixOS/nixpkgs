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
  version = "0.5.2";

  src = fetchCrate {
    inherit version;
    crateName = pname;
    sha256 = "1mxl71yz2iy5s6pbp33cwkfzzilkla4qqiskd6jsd5fdlrrwlxqm";
  };

  cargoSha256 = "19gznam64s17kha3accgjks5rmd9kpqqgxg3dfrk7fg5v4431007";

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
    changelog = "https://git.tozt.net/rbw/plain/CHANGELOG.md?id=${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham luc65r marsam ];
  };
}
