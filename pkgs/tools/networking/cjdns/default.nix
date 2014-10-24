{ stdenv, fetchFromGitHub, nodejs, which, python27 }:

let
  date = "20141023";
  rev = "c7eed6b14688458e16fab368f68904e530651a30";
in
stdenv.mkDerivation {
  name = "cjdns-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    inherit rev;
    sha256 = "11z8dk7byxh9pfv7mhfvnk465qln1g7z8c8f822623d59lwjpbs1";
  };

  buildInputs = [ which python27 nodejs];

  buildPhase = "bash do";
  installPhase = "installBin cjdroute makekeys privatetopublic publictoip6";

  meta = with stdenv.lib; {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric emery ];
    platforms = platforms.unix;
  };
}
