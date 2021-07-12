{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, rustPlatform
, cargo
, Security
, libiconv
, withDocs ? true
, sphinx
, withPrefix ? false
, buildMulticallBinary ? true
}:

let
  prefix = "uutils-";
in
stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "unstable-2021-07-09";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = "2177b8dc37d9c8705b3c59efe7c5e10a69dce182";
    sha256 = "sha256-2eKvHzGY2gi3gC2LhhsgZu+NJwf0/JyRstNxcueFnTk=";
  };

  # second replace can be removed when https://github.com/uutils/coreutils/pull/2491 is merged
  postPatch = ''
    # don't enforce the building of the man page
    substituteInPlace GNUmakefile \
      --replace 'install: build' 'install:' \
      --replace 'LLEES)), ln -fs' 'LLEES)), cd $(INSTALLDIR_BIN) && ln -fs'
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-FDds2kRR1SstHSzg0Tg/oQk8oHbhNqBsaOjzV7edKd0=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ]
    ++ lib.optional withDocs sphinx;

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  makeFlags = [
    "CARGO=${cargo}/bin/cargo"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
  ] ++ lib.optionals withPrefix [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ]
  ++ lib.optionals (!withDocs) [ "build-coreutils" "build-pkgs" ];

  # https://github.com/uutils/coreutils/pull/2490
  preBuild = ''
    mkdir -p $out/share/{zsh/site-functions,bash-completion/completions,fish/vendor_completions.d}
  '';

  # too many impure/platform-dependent tests
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/uutils/coreutils.git";
  };

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    maintainers = with maintainers; [ siraben SuperSandro2000 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
