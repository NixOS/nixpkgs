{ lib
, stdenv
, fetchFromGitHub
, coreutils
, sharutils
, runtimeShell
, version
, sha256
}:

stdenv.mkDerivation {
  pname = "vimpager";
  inherit version;

  src = fetchFromGitHub {
    owner = "rkitover";
    repo = "vimpager";
    rev = version;
    inherit sha256;
  };

  nativeBuildInputs = [ sharutils ]; # for uuencode
  buildInputs = [ coreutils ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preBuild = ''
    sed -i 's,/bin/cat,${coreutils}/bin/cat,g' vimpager
  '';

  meta = with lib; {
    description = "Use Vim as PAGER";
    homepage = "https://www.vim.org/scripts/script.php?script_id=1723";
    license = with licenses; [ bsd2 mit vim ];
    platforms = platforms.unix;
    maintainers = with maintainers; [];
  };
}
