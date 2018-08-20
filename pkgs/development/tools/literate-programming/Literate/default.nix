{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  name = "Literate-2017-05-28";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "23928d64bb19b5101dbcc794da6119beaf59f679";
    sha256 = "094lramvacarzj8443ns18zyv7dxnivwi7kdk5xi5r2z4gx338iq";
  };

  buildInputs = [ dmd dub ];

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with stdenv.lib; {
    description = "A literate programming tool for any language";
    homepage    = http://literate.zbyedidia.webfactional.com/;
    license = licenses.mit;
    platforms = platforms.unix;
    broken = true; # 2018-08-20 (https://github.com/NixOS/nixpkgs/pull/45355#issuecomment-414285384)
  };
}
