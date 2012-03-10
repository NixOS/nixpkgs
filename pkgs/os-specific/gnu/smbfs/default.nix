{ fetchcvs, stdenv, hurd, machHeaders, samba }:

let
  date = "2012-03-08";
  samba_patched = stdenv.lib.overrideDerivation samba (attrs: {
    patches = attrs.patches ++ [ ./samba-without-byte-range-locks.patch ];
  });
in
stdenv.mkDerivation rec {
  name = "smbfs-${date}";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.savannah.nongnu.org:/sources/hurdextras";
    module = "smbfs";
    sha256 = "526475771e145a43752a9a6b9ff60cbed24cb6c098cafc490ab42684936fd685";
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
