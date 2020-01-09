{ stdenv, fetchFromGitHub, rustPlatform, cargo, cmake, sphinx, lib, prefix ? "uutils-"
, Security
}:

rustPlatform.buildRustPackage {
  name = "uutils-coreutils-2019-05-03";
  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = "036dd812958ace22d973acf7b370f58072049dac";
    sha256 = "0d9w3iiphhsk7l5l34682wayp90rgq5a3d94l3qdvhcqkfmpg727";
  };

  # too many impure/platform-dependent tests
  doCheck = false;

  cargoSha256 = "0qnpx2xhckb45q8cgn0xh31dg5k73hqp5mz5zg3micmg7as4b621";

  makeFlags =
    [ "CARGO=${cargo}/bin/cargo" "PREFIX=$(out)" "PROFILE=release" "INSTALLDIR_MAN=$(out)/share/man/man1" ]
    ++ lib.optional (prefix != null) [ "PROG_PREFIX=${prefix}" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cargo sphinx ] ++ lib.optional stdenv.isDarwin Security;

  # empty {build,install}Phase to use defaults of `stdenv.mkDerivation` rather than rust defaults
  buildPhase = "";
  installPhase = "";

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = https://github.com/uutils/coreutils;
    maintainers = with maintainers; [ ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
