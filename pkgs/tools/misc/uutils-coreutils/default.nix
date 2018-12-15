{ stdenv, fetchFromGitHub, rustPlatform, cargo, cmake, sphinx, lib, prefix ? "uutils-" }:

rustPlatform.buildRustPackage {
  name = "uutils-coreutils-2018-09-30";
  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = "a161b7e803aef08455ae0547dccd9210e38a4574";
    sha256 = "19j40cma7rz6yf5j6nyid8qslbcmrnxdk6by53hflal2qx3g555z";
  };

  # too many impure/platform-dependent tests
  doCheck = false;

  cargoSha256 = "1a9k7i4829plkxgsflmpji3mrw2i1vln6jsnhxmkl14h554yi5j4";

  makeFlags =
    [ "CARGO=${cargo}/bin/cargo" "PREFIX=$(out)" "PROFILE=release" "INSTALLDIR_MAN=$(out)/share/man/man1" ]
    ++ lib.optional (prefix != null) [ "PROG_PREFIX=${prefix}" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cargo sphinx ];

  # empty {build,install}Phase to use defaults of `stdenv.mkDerivation` rather than rust defaults
  buildPhase = "";
  installPhase = "";

  meta = with stdenv.lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = https://github.com/uutils/coreutils;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
