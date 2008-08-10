args: with args;

stdenv.mkDerivation {
  name = "reiserfsprogs-3.6.19-patched";

  src = fetchurl {
    url = http://chichkin_i.zelnet.ru/namesys/reiserfsprogs-3.6.19.tar.gz;
    sha256 = "1gv8gr0l5l2j52540y2wj9c9h7fn0r3vabykf95748ydmr9jr1n0";
  };

  patches = [./headers-fix.patch ./verbose-flag-ignore-for-compatibility.patch ];

  meta = {
    homepage = http://www.namesys.com/;
    description = "Reiserfs utilities";
    license = "GPL-2";
  };
}
