{ skawarePackages }:

skawarePackages.buildPackage {
  pname = "skalibs";
  version = "2.10.0.3";
  sha256 = "0ka6n5rnxd5sn5lycarf596d5wlak5s535zqqlz0rnhdcnpb105p";

  meta.description = "Set of general-purpose C programming libraries";

  outputs = [
    "lib"
    "dev"
    "doc"
    "out"
  ];

  configureFlags = [
    "--libdir=${placeholder "lib"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "lib"}/libexec"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    # assume /dev/random works
    "--enable-force-devr"
    "--sysdepdir=\${lib}/lib/skalibs/sysdeps"
    # Empty the default path, which would be "/usr/bin:bin".
    # It would be set when PATH is empty. This hurts hermeticity.
    "--with-default-path="
  ];

  postInstall = ''
    rm -rf sysdeps.cfg
    rm libskarnet.*

    mv doc $doc/share/doc/skalibs/html
  '';

}
