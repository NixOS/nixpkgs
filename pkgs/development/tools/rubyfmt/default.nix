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
, libyaml
, rust-jemalloc-sys-unprefixed
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rubyfmt";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "fables-tales";
    repo = "rubyfmt";
    rev = "v${version}";
    hash = "sha256-IIHPU6iwFwQ5cOAtOULpMSjexFtTelSd/LGLuazdmUo=";
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
    libyaml
    rust-jemalloc-sys-unprefixed
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
    # Avoid checking whether ruby gitsubmodule is up-to-date.
    ./0002-remove-dependency-on-git.patch
    # Avoid failing on unused variable warnings.
    ./0003-ignore-warnings.patch
  ];

  cargoHash = "sha256-QZ26GmsKyENkzdCGg2peie/aJhEt7KQAF/lwsibonDk=";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-fdeclspec";

  preFixup = ''
    mv $out/bin/rubyfmt{-main,}
  '';

  meta = {
    description = "Ruby autoformatter";
    homepage = "https://github.com/fables-tales/rubyfmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    broken = stdenv.isDarwin;
    mainProgram = "rubyfmt";
  };
}
