{ lib
, stdenv
, rustPlatform
, fetchCrate
, openssl
, pkg-config
, makeWrapper
, installShellFiles
, Security
, libiconv

# rbw-fzf
, withFzf ? false, fzf, perl

# rbw-rofi
, withRofi ? false, rofi, xclip

# pass-import
, withPass ? false, pass
}:

rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "1.3.0";

  src = fetchCrate {
    inherit version;
    crateName = pname;
    sha256 = "17x4q29rsljbalc70r3ks4r6g5zc6jl4si75i33fcicxsvx6f39q";
  };

  cargoSha256 = "14095ds8f5knrqcriphjlbvasc29n9rf8h5vlkmhpxyk7wh9azzc";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  postPatch = lib.optionalString withFzf ''
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

  postInstall = ''
    for shell in bash zsh fish; do
      $out/bin/rbw gen-completions $shell > rbw.$shell
      installShellCompletion rbw.$shell
    done
  '' + lib.optionalString withFzf ''
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
