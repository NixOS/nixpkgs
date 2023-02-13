{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, autoconf
, automake
, bison
, ruby
, zlib
, readline
, libiconv
, libobjc
, libunwind
, libxcrypt
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rubyfmt";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "fables-tales";
    repo = "rubyfmt";
    rev = "v${version}";
    hash = "sha256-lHq9lcLMp6HUHMonEe3T2YGwMYW1W131H1jo1cy6kyc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    bison
    ruby
  ];

  buildInputs = [
    zlib
    libxcrypt
  ] ++ lib.optionals stdenv.isDarwin [
    readline
    libiconv
    libobjc
    libunwind
    Foundation
    Security
  ];

  preConfigure = ''
    pushd librubyfmt/ruby_checkout
    autoreconf --install --force --verbose
    ./configure
    popd
  '';

  cargoPatches = [
    # The 0.8.1 release did not have an up-to-date lock file. The rubyfmt
    # version in Cargo.toml was bumped, but it wasn't updated in the lock file.
    ./0001-cargo-lock-update-version.patch

    # Avoid checking whether ruby gitsubmodule is up-to-date.
    ./0002-remove-dependency-on-git.patch
  ];

  cargoHash = "sha256-keeIonGNgE0U0IVi8DeXAy6ygTXVXH+WDjob36epUDI=";

  preFixup = ''
    mv $out/bin/rubyfmt{-main,}
  '';

  meta = with lib; {
    description = "A Ruby autoformatter";
    homepage = "https://github.com/fables-tales/rubyfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}
