{ stdenv, fetchurl, fetchpatch, autoreconfHook
, IOKit ? null , ApplicationServices ? null }:

let
  version = "6.6";

  dbrev = "4852";
  drivedbBranch = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}_DRIVEDB";
  driverdb = fetchurl {
    url    = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "15gbwiw38yzl3cdvys6r7wknv5zdycm7zbswa2p9vzxlc8s63rlr";
    name   = "smartmontools-drivedb.h";
  };

in stdenv.mkDerivation rec {
  name = "smartmontools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "0m1hllbb78rr6cxkbalmz1gqkl0psgq8rrmv4gwcmz34n07kvx2i";
  };

  patches = [ ./smartmontools.patch ]
    # https://www.smartmontools.org/changeset/4603
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "musl-canonicalize_file_name.patch";
      url = "https://www.smartmontools.org/changeset/4603?format=diff&new=4603";
      sha256 = "06s9pcd95snjkrbfrsjby2lln3lnwjd21bgabmvr4p7fx19b75zp";
      stripLen = 2;
    });
  postPatch = "cp -v ${driverdb} drivedb.h";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage    = https://www.smartmontools.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms   = with platforms; linux ++ darwin;
  };
}
