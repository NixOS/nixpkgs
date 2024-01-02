{ lib
, stdenv
, rustPlatform
, fetchzip
, openssl
, pkg-config
, installShellFiles
, darwin

  # rbw-fzf
, withFzf ? false
, fzf
, perl

  # rbw-rofi
, withRofi ? false
, rofi
, xclip

  # pass-import
, withPass ? false
, pass
}:

rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "1.8.3";

  src = fetchzip {
    url = "https://git.tozt.net/rbw/snapshot/rbw-${version}.tar.gz";
    sha256 = "sha256-dC/x+ihH1POIFN/8pbk967wATXKU4YVBGI0QCo8d+SY=";
  };

  cargoHash = "sha256-nI1Pf7gREbAk+JVF3Gn2j8OqprexCQ5fVvECtq2aBPM=";

  nativeBuildInputs = [
    installShellFiles
  ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.AppKit
  ];

  preConfigure = lib.optionalString stdenv.isLinux ''
    export OPENSSL_INCLUDE_DIR="${openssl.dev}/include"
    export OPENSSL_LIB_DIR="${lib.getLib openssl}/lib"
  '';

  postInstall = ''
    install -Dm755 -t $out/bin bin/git-credential-rbw
    installShellCompletion --cmd rbw \
      --bash <($out/bin/rbw gen-completions bash) \
      --fish <($out/bin/rbw gen-completions fish) \
      --zsh <($out/bin/rbw gen-completions zsh)
  '' + lib.optionalString withFzf ''
    install -Dm755 -t $out/bin bin/rbw-fzf
    substituteInPlace $out/bin/rbw-fzf \
      --replace fzf ${fzf}/bin/fzf \
      --replace perl ${perl}/bin/perl
  '' + lib.optionalString withRofi ''
    install -Dm755 -t $out/bin bin/rbw-rofi
    substituteInPlace $out/bin/rbw-rofi \
      --replace rofi ${rofi}/bin/rofi \
      --replace xclip ${xclip}/bin/xclip
  '' + lib.optionalString withPass ''
    install -Dm755 -t $out/bin bin/pass-import
    substituteInPlace $out/bin/pass-import \
      --replace pass ${pass}/bin/pass
  '';

  meta = with lib; {
    description = "Unofficial command line client for Bitwarden";
    homepage = "https://crates.io/crates/rbw";
    changelog = "https://git.tozt.net/rbw/plain/CHANGELOG.md?id=${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham luc65r marsam ];
  };
}
