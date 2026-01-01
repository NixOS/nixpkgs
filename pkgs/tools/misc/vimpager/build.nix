{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  sharutils,
  version,
  sha256,
}:

stdenv.mkDerivation {
  inherit version;
  pname = "vimpager";

  src = fetchFromGitHub {
    inherit sha256;

    owner = "rkitover";
    repo = "vimpager";
    rev = version;
  };

  nativeBuildInputs = [ sharutils ]; # for uuencode
  buildInputs = [ coreutils ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildPhase = ''
    sed -i 's,/bin/cat,${coreutils}/bin/cat,g' vimpager
    make
  '';

<<<<<<< HEAD
  meta = {
    description = "Use Vim as PAGER";
    homepage = "https://www.vim.org/scripts/script.php?script_id=1723";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Use Vim as PAGER";
    homepage = "https://www.vim.org/scripts/script.php?script_id=1723";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bsd2
      mit
      vim
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
