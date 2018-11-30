{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  name = "Literate-2018-08-20";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "737567e49c9e12ac56222c147191da58ea1521e2";
    sha256 = "19v8v66lv8ayg3irqkbk7ln5lkmgwpx4wgz8h3yr81arl40bbzqs";
  };

  buildInputs = [ dmd dub ];

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with stdenv.lib; {
    description = "A literate programming tool for any language";
    homepage    = http://literate.zbyedidia.webfactional.com/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
