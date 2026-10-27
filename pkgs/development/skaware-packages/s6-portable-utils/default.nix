{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "s6-portable-utils";
  version = "2.3.1.2";
  sha256 = "sha256-z7kBhtDA6yBOHlxvk3nplBPFRrzPOLtudhd/gjcao6o=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-portable-utils-man-pages";
    version = "2.3.1.1.2";
    sha256 = "sha256-WJxSSJVRY8Hz9QYwu81Qz90Tu2KHl8F3WeeZxFyK3gU=";
    description = "Port of the documentation for the s6-portable-utils suite to mdoc";
    maintainers = [ lib.maintainers.somasis ];
  };

  meta.description = "Set of tiny general Unix utilities optimized for simplicity and small size";

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];

  buildInputs = [ skalibs ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "out"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm seekablepipe

    mv doc $doc/share/doc/s6-portable-utils/html
  '';

}
