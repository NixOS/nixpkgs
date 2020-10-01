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
  version = "0.4.6";

  src = fetchCrate {
    inherit version;
    crateName = "${pname}";
    sha256 = "0vq7cwk3i57fvn54q2rgln74j4p9vqm5zyhap94s73swjywicwk0";
  };

  cargoSha256 = "1h253ncick2v9aki5rf1bdrg5rj3h4nrvx5q01gw03cgwnqvyiiy";

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
    maintainers = with maintainers; [ albakham luc65r ];
    platforms = platforms.all;
  };
}
