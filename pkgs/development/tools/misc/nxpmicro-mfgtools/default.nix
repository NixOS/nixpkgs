{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, bzip2
, libusb1
, libzip
, openssl
}:

stdenv.mkDerivation rec {
  pname = "nxpmicro-mfgtools";
  version = "1.3.191";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = "mfgtools";
    rev = "uuu_${version}";
    sha256 = "196blmd7nf5kamvay22rvnkds2v6h7ab8lyl10dknxgy8i8siqq9";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ bzip2 libusb1 libzip openssl ];

  preConfigure = "echo ${version} > .tarball-version";

  meta = with stdenv.lib; {
    description = "Freescale/NXP I.MX chip image deploy tools";
    longDescription = ''
      UUU (Universal Update Utility) is a command line tool, evolved out of
      MFGTools (aka MFGTools v3).

      One of the main purposes is to upload images to I.MX SoC's using at least
      their boot ROM.

      With time, the need for an update utility portable to Linux and Windows
      increased. UUU has the same usage on both Windows and Linux. It means the same
      script works on both OS.
    '';
    homepage = "https://github.com/NXPmicro/mfgtools";
    license = licenses.bsd3;
    maintainers = [ maintainers.bmilanov ];
    platforms = platforms.all;
  };
}
