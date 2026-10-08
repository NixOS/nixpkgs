{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "mdevd";
  version = "0.1.8.2";
  sha256 = "sha256-zhrgFJtqV6NPYIIY/WGBqmqmgTXKwvTZMbW0F7By4kQ=";

  meta.description = "mdev-compatible Linux hotplug manager daemon";
  meta.platforms = lib.platforms.linux;

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
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
    # remove all mdevd executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libmdevd.*

    mv doc $doc/share/doc/mdevd/html
    mv examples $doc/share/doc/mdevd/examples
  '';
}
