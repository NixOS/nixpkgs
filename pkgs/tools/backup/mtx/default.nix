{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mtx";
  version = "1.3.12";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-stable/${version}/${pname}-${version}.tar.gz";
    sha256 = "0261c5e90b98b6138cd23dadecbc7bc6e2830235145ed2740290e1f35672d843";
  };

  doCheck = false;

  meta = {
    description = "Media Changer Tools";
    longDescription = ''
      The mtx command controls single or multi-drive SCSI media changers such as
      tape changers, autoloaders, tape libraries, or optical media jukeboxes. It
      can also be used with media changers that use the 'ATTACHED' API, presuming
      that they properly report the MChanger bit as required by the SCSI T-10 SMC
      specification.
    '';
    homepage = "https://sourceforge.net/projects/mtx/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.linux;
  };
}
