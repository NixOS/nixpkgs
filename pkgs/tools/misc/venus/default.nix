{ stdenv, fetchFromGitHub, python, pythonPackages, libxslt, libxml2, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "venus";
  version = "unstable-2011-02-18";

  src = fetchFromGitHub {
    owner = "rubys";
    repo = "venus";
    rev = "9de21094a8cf565bdfcf75688e121a5ad1f5397b";
    sha256 = "10yyx4jaxxbwhica12aiw119aywghcr7b24gs9lrmafpa6xd3an2";
  };

  preConfigure = ''
    substituteInPlace tests/test_spider.py \
        --replace "urllib.urlopen('http://127.0.0.1:%d/' % _PORT).read()" "" \
        --replace "[200,200,200,200,404]" "[200,200,200,404]"
    substituteInPlace planet.py \
        --replace "#!/usr/bin/env python" "#!${python}/bin/python"
    substituteInPlace tests/test_apply.py \
        --replace "'xsltproc" "'${libxslt.bin}/bin/xsltproc"
    substituteInPlace planet/shell/xslt.py \
        --replace "'xsltproc" "'${libxslt.bin}/bin/xsltproc"
  '';

  doCheck = true;
  checkPhase = "python runtests.py";

  buildInputs = [ python libxslt
    libxml2 pythonPackages.genshi pythonPackages.lxml makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R ./* $out/
    ln -s $out/planet.py $out/bin/venus-planet
    wrapProgram $out/planet.py \
        --prefix PYTHONPATH : $PYTHONPATH:${pythonPackages.lxml}/lib/${python.libPrefix}/site-packages:${pythonPackages.genshi}/lib/${python.libPrefix}/site-packages
    python runtests.py
  '';

  meta = {
    description = "News feed reader";
    longDescription = ''
      Planet Venus is an awesome ‘river of news’ feed reader. It downloads news
      feeds published by web sites and aggregates their content together into a
      single combined feed, latest news first.
    '';
    homepage = http://intertwingly.net/code/venus/docs/index.html;
    license = stdenv.lib.licenses.psfl;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
