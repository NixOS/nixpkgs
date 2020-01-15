{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsatrace";
  version = "0.0.1-160";

  src = fetchFromGitHub {
    owner = "jacereda";
    repo = "fsatrace";
    rev = "2bf89d836e0156e68f121b0ffeedade7c9381f77";
    sha256 = "0bndfmm0y738azwzf6m6xg6gjnrwcqlfjsampk67vga40yylwkbw";
  };

  preConfigure = ''
    mkdir -p $out/libexec/${pname}-${version}
    export makeFlags=INSTALLDIR=$out/libexec/${pname}-${version}
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/libexec/${pname}-${version}/fsatrace $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jacereda/fsatrace;
    description = "filesystem access tracer";
    license = licenses.isc;
    maintainers = [ maintainers.peti ];
    platforms = platforms.linux;
  };
}
