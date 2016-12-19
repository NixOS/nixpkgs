{ stdenv, fetchurl, unzip }:

let baseName = "premake";
  version  = "4.3";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${baseName}/${baseName}-${version}-src.zip";
    sha256 = "1017rd0wsjfyq2jvpjjhpszaa7kmig6q1nimw76qx3cjz2868lrn";
  };

  buildInputs = [ unzip ];

  buildPhase = ''
    make -C build/gmake.unix/
  '';

  installPhase = ''
    install -Dm755 bin/release/premake4 $out/bin/premake4
  '';

  meta = with stdenv.lib; {
    homepage = http://industriousone.com/premake;
    description = "A simple build configuration and project generation tool using lua";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
