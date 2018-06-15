{ stdenv, fetchgit, python, libev}:
stdenv.mkDerivation rec {
  name = "weighttp-${version}";
  version = "0.4";

  src = fetchgit {
    url = https://git.lighttpd.net/weighttp.git;
    rev = "refs/tags/weighttp-${version}";
    sha256 = "14yjmdx9p8g8c3zlrx5qid8k156lsagfwhl3ny54162nxjf7kzgr";
  };

  buildInputs = [ python libev ];
  installPhase = ''
    python waf configure --prefix=$out
    python waf build
    python waf install
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
