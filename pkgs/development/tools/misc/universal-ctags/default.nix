{ lib
, stdenv
, autoreconfHook
, buildPackages
, coreutils
, fetchFromGitHub
, jansson
, libiconv
, perl
, pkg-config
, python3
, libseccomp
, libyaml
, pcre2
, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "universal-ctags";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f8+Ifjn7bhSYozOy7kn+zCLdHGrH3iFupHUZEGynz9Y=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    (python3.withPackages (p: [ p.docutils ]))
  ];

  buildInputs = [
    libyaml
    pcre2
    libxml2
    jansson
  ]
  ++ lib.optional stdenv.isDarwin libiconv
  ++ lib.optional stdenv.isLinux libseccomp;

  configureFlags = [ "--enable-tmpdir=/tmp" ];

  patches = [
    ./000-nixos-specific.patch
  ];

  postPatch = ''
    substituteInPlace Tmain/utils.sh \
      --replace /bin/echo ${coreutils}/bin/echo
    # fails on sandbox
    rm -fr Tmain/ptag-proc-cwd.d/
    patchShebangs misc/*
  '';

  doCheck = true;

  checkFlags = [
    "man-test" "tlib" "tmain" "tutil" "units"
  ];

  meta = with lib; {
    homepage = "https://docs.ctags.io/en/latest/";
    description = "Maintained ctags implementation";
    longDescription = ''
      Universal Ctags (abbreviated as u-ctags) is a maintained implementation of
      ctags. ctags generates an index (or tag) file of language objects found in
      source files for programming languages. This index makes it easy for text
      editors and other tools to locate the indexed items.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.all;
    mainProgram = "ctags";
    priority = 1; # over the emacs implementation
  };
})
