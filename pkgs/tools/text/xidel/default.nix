{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  name = "xidel-${version}";
  version = "0.9.6";

  ## Source archive lacks file (manageUtils.sh), using pre-built package for now.
  #src = fetchurl {
  #  url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/${name}.src.tar.gz";
  #  sha256 = "1h5xn16lgzx0s94iyhxa50lk05yf0af44nzm5w5k57615nd82kz2";
  #};

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/xidel_${version}-1_amd64.deb";
        sha256 = "0hskc74y7p4j1x33yx0w4fvr610p2yimas8pxhr6bs7mb9b300h7";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/xidel_${version}-1_i386.deb";
        sha256 = "07yk5sk1p4jm0jmgjwdm2wq8d2wybi1wkn1qq5j5y03z1pdc3fi6";
      }
    else throw "xidel is not supported on ${stdenv.system}";

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp -a usr/* "$out/"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/xidel"
  '';

  meta = with stdenv.lib; {
    description = "Command line tool to download and extract data from html/xml pages";
    homepage = http://videlibri.sourceforge.net/xidel.html;
    # source contains no license info (AFAICS), but sourceforge says GPLv2
    license = licenses.gpl2;
    # more platforms will be supported when we switch to source build
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
