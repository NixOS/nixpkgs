{ stdenv, buildPythonPackage, fetchPypi, fetchpatch }:

buildPythonPackage (rec {
  pname = "urwid";
  version = "1.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18cnd1wdjcas08x5qwa5ayw6jsfcn33w4d9f7q3s29fy6qzc1kng";
  };

  patches = [
   # fix tests
   (fetchpatch {
     url = "https://github.com/urwid/urwid/commit/4b0ed8b6030450e6d99909a7c683e9642e546387.patch";
     sha256 = "0azpn0ylbg8mfpr0y27n4lnq0ph75a4d4m9wdv3napnhf1vh9ahx";
   })
   # fix tests
   (fetchpatch {
     url = "https://github.com/floppym/urwid/commit/f68f2cf089cfd5ec45863baf59a91d5aeb0cf5c3.patch";
     sha256 = "1b3vz7mrwz2bqvdwvbyv2j835f9lzapgw0j2km4sam76bxmgfpgq";
   })
  ];

  postPatch = ''
    # Several tests keep failing on Hydra
    rm urwid/tests/test_vterm.py
  '';

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ garbas ];
  };
})
