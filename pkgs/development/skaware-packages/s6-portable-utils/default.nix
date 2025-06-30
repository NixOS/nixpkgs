{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "s6-portable-utils";
  version = "2.3.1.0";
  sha256 = "sha256-BCRKqHrixBLUmZdptec8tCivugwuiqkhWzo2574qgPk=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-portable-utils-man-pages";
    version = "2.3.0.4.1";
    sha256 = "sha256-LbXa+fecxYyFdVmEHT8ch4Y8Pf1YIyd9Gia3zujxUgs=";
    description = "Port of the documentation for the s6-portable-utils suite to mdoc";
    maintainers = [ lib.maintainers.somasis ];
  };

  description = "Set of tiny general Unix utilities optimized for simplicity and small size";

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
