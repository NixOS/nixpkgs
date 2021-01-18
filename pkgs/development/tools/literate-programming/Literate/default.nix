{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  pname = "Literate";
  version = "unstable-2020-09-02";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "533991cca6ec7a608a778396d32d51b35182d944";
    sha256 = "09h1as01z0fw0bj0kf1g9nlhvinya7sqq2x8qb6zmhvqqm6v4n49";
  };

  buildInputs = [ dmd dub ];

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with stdenv.lib; {
    description = "A literate programming tool for any language";
    homepage    = "http://literate.zbyedidia.webfactional.com/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
