{
  apple-sdk_11,
  fetchpatch2,
  libutil,
  mkAppleDerivation,
  ncurses,
  pkg-config,
}:

let
  xnu = apple-sdk_11.sourceRelease "xnu";
in
mkAppleDerivation {
  releaseName = "top";

  xcodeHash = "sha256-TuBdZztwCpNwPP0er+7h6FoPV9AbdZAXpzGcqBAuD5Y=";

  postPatch = ''
    # Fix duplicate symbol error. `tsamp` is unused in `main.c`.
    substituteInPlace main.c \
      --replace-fail 'const libtop_tsamp_t *tsamp;' ""

    # Adding the whole sys folder causes header conflicts, so copy only the private headers that are needed.
    mkdir sys
    cp ${xnu}/bsd/sys/{kern_memorystatus.h,reason.h} sys/
  '';

  buildInputs = [
    apple-sdk_11
    libutil
    ncurses
  ];

  nativeBuildInputs = [ pkg-config ];

  meta.description = "Display information about processes";
}
