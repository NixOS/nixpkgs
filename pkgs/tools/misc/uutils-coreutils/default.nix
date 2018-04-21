{ stdenv, fetchFromGitHub, rustPlatform, cargo, cmake, sphinx, lib, prefix ? "uutils-" }:

rustPlatform.buildRustPackage {
  name = "uutils-coreutils-2018-02-09";
  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = "f333ab26b03294a32a10c1c203a03c6b5cf8a89a";
    sha256 = "0nkggs5nqvc1mxzzgcsqm1ahchh4ll11xh0xqmcljrr5yg1rhhzf";
  };

  # too many impure/platform-dependent tests
  doCheck = false;

  cargoSha256 = "0qv2wz1bxhm5xhzbic7cqmn8jj8fyap0s18ylia4fbwpmv89nkc5";

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
    platforms = platforms.linux;
  };
}
