{
  apple-sdk,
  fetchpatch2,
  libutil,
  mkAppleDerivation,
  ncurses,
  pkg-config,
}:

let
  xnu = apple-sdk.sourceRelease "xnu";
in
mkAppleDerivation {
  releaseName = "top";

  xcodeHash = "sha256-b7Qv9ks9JmilY9GaEU3/iXoHBNyHRYr4IB0jVf0fYdo=";

  patches = [
    # Upstream removed aarch64 support from the 137 source release, but the removal can be reverted.
    # Otherwise, top will fail to run on aarch64-darwin.
    # Based on https://github.com/apple-oss-distributions/top/commit/a989bd5d18246e330e5feadd80958b913351f8ae.diff
    ./patches/0001-Revert-change-that-dropped-aarch64-support.patch
  ];

  postPatch = ''
    # Fix duplicate symbol error. `tsamp` is unused in `main.c`.
    substituteInPlace main.c \
      --replace-fail 'const libtop_tsamp_t *tsamp;' ""

    # Adding the whole sys folder causes header conflicts, so copy only the private headers that are needed.
    mkdir sys
    cp ${xnu}/bsd/sys/{kern_memorystatus.h,reason.h} sys/
  '';

  buildInputs = [
    libutil
    ncurses
  ];

  nativeBuildInputs = [ pkg-config ];

  meta.description = "Display information about processes";
}
