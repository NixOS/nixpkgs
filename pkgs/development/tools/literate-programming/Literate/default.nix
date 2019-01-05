{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  name = "Literate-2018-12-23";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "99a0b7dd1ac451c2386094be06364df9386c3862";
    sha256 = "0jvciajr33iz049m0yal41mz9p8nxmwkpq2mrfhg1ysx2zv3q3pm";
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
