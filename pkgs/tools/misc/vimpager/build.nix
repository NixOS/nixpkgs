{ stdenv
, fetchFromGitHub
, coreutils
, sharutils
, version
, sha256
}:

stdenv.mkDerivation rec {
  inherit version;
  pname = "vimpager";

  src = fetchFromGitHub {
    inherit sha256;

    owner  = "rkitover";
    repo   = "vimpager";
    rev    = "${version}";
  };

  buildInputs = [ coreutils sharutils ]; # for uuencode

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildPhase = ''
    sed -i 's,/bin/cat,${coreutils}/bin/cat,g' vimpager
    make
  '';


  meta = with stdenv.lib; {
    description = "Use Vim as PAGER";
    homepage    = "https://www.vim.org/scripts/script.php?script_id = 1723";
    license     = with licenses; [ bsd2 mit vim ];
    platforms   = platforms.unix;
  };
}
