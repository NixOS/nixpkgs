{ stdenv, fetchurl, imake, bison, flex, gccmakedep
, xorgproto, libXau, libXt, libXext, libXaw, libXpm, xorgcffiles }:

let
  pname = "nas";
  version = "1.9.4";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.src.tar.gz";
    sha256 = "17dk0ckm6mp1ajc0cd6bwyi638ynw2f6bhbn7gynrs0wfmiyldng";
  };

  nativeBuildInputs = [ imake bison flex gccmakedep ];

  buildInputs = [ xorgproto libXau libXt libXext libXaw libXpm ];

  buildFlags = [ "WORLDOPTS=" "World" ];

  installFlags = [ "LDLIBS=-lfl" "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    mv $out/${xorgcffiles}/* $out
    rm -r $out/nix
  '';

  meta = with stdenv.lib; {
    description = "A network transparent, client/server audio transport system";
    homepage = http://radscan.com/nas.html;
    license = licenses.mit;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
