{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "s6-portable-utils";
  version = "2.3.0.3";
  sha256 = "PkSSBV0WDCX7kBU/DvwnfX1Sv5gbvj6i6d/lHEk1Yf8=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-portable-utils-man-pages";
    version = "2.3.0.2.2";
    sha256 = "0zbxr6jqrx53z1gzfr31nm78wjfmyjvjx7216l527nxl9zn8nnv1";
    description = "Port of the documentation for the s6-portable-utils suite to mdoc";
    maintainers = [ lib.maintainers.somasis ];
  };

  description = "A set of tiny general Unix utilities optimized for simplicity and small size";

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm seekablepipe

    mv doc $doc/share/doc/s6-portable-utils/html
  '';

}
