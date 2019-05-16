{ lib, fetchurl, runCommandCC, skawarePackages }:

with skawarePackages;

let
  # From https://skarnet.org/software/misc/sdnotify-wrapper.c,
  # which is unversioned.
  src = ./sdnotify-wrapper.c;

in runCommandCC "sdnotify-wrapper" {

   outputs = [ "bin" "doc" "out" ];

   meta = {
     homepage = "https://skarnet.org/software/misc/sdnotify-wrapper.c";
     description = "Use systemd sd_notify without having to link against libsystemd";
     platforms = lib.platforms.all;
     license = lib.licenses.isc;
     maintainers = with lib.maintainers; [ Profpatsch ];
   };

} ''
  mkdir -p $bin/bin
  mkdir $out

  # just dynamic for now
  $CC \
    -o $bin/bin/sdnotify-wrapper \
    -I${skalibs.dev}/include \
    -L${skalibs.lib}/lib \
    -lskarnet \
    ${src}

  mkdir -p $doc/share/doc/sdnotify-wrapper
  # copy the documentation comment
  sed -ne '/Usage:/,/*\//p' ${src} > $doc/share/doc/sdnotify-wrapper/README
''
