{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, sphinx
, Security
, libiconv
, prefix ? "uutils-"
, buildMulticallBinary ? true
}:

stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    hash = "sha256-aEhU4O4xoj7hrnmNXA9GQYn8nc6XEJCGQIcx/xRtLMc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-zQN6EVRyd4FWeNNDXI3NY6XWmJTD+n8c+w7BHtXvs1k=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook sphinx ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  makeFlags = [
    "CARGO=${cargo}/bin/cargo"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
  ] ++ lib.optionals (prefix != null) [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ];

  # too many impure/platform-dependent tests
  doCheck = false;

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
