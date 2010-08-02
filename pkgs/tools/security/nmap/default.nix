{ stdenv, fetchurl, libpcap, libX11, gtk, pkgconfig
, openssl, python, pygtk, makeWrapper, pygobject
, pycairo, pysqlite
}:
  
stdenv.mkDerivation rec {
  name = "nmap-5.21";

  src = fetchurl {
    url = "http://nmap.org/dist/${name}.tar.bz2";
    sha256 = "1fmh05iamynmr8zic3bja6dr0pfiwp0hr2nc2wpiqm2pc7w29jwz";
  };

  patches =
    [ (fetchurl {
        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-analyzer/nmap/files/nmap-5.21-openssl-1.patch?revision=1.1";
        sha256 = "0q0kgwvg5b770xpp31a5a3lxh8d5ik6d5bv11nlh3syd78q6f08y";
      })
    ];

  patchFlags = "-p0";

  postInstall =
    ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath ${pygtk})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pygobject})/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath ${pycairo})/gtk-2.0
    '';

  buildInputs =
    [ libpcap libX11 gtk pkgconfig openssl python pygtk makeWrapper pysqlite ];
}
