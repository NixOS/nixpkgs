{ fetchcvs, stdenv, hurd, machHeaders, samba }:

let
  date = "2012-03-15";
  samba_patched = stdenv.lib.overrideDerivation samba (attrs: {
    patches = attrs.patches ++ [ ./samba-without-byte-range-locks.patch ];
  });
in
stdenv.mkDerivation rec {
  name = "smbfs-${date}";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.savannah.nongnu.org:/sources/hurdextras";
    module = "smbfs";
    sha256 = "5941d1a5da4488cbf0efe9aa0b41fe4ff5ba57b84ed24f7ff7c0feda4501d3e3";
    inherit date;
  };

  patchPhase =
    '' sed -i "Makefile" \
           -e 's|gcc|i586-pc-gnu-gcc|g ;
               s|^LDFLAGS=\(.*\)$|LDFLAGS=\1 -pthread|g'
    '';

  buildInputs = [ hurd machHeaders samba_patched ];

  installPhase =
    '' mkdir -p "$out/hurd"
       cp -v smbfs "$out/hurd"

       mkdir -p "$out/share/doc/${name}"
       cp -v README "$out/share/doc/${name}"
    '';

  meta = {
    description = "SMB/CIFS file system translator for GNU/Hurd";

    homepage = http://www.nongnu.org/hurdextras/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
