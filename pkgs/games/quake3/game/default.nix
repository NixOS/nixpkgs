{stdenv, fetchurl, x11, SDL, mesa, openal}:

# To run: ./ioquake3.i386 +set r_allowSoftwareGL 1

/* To get hardware acceleration of NVidia cards:

[eelco@hagbard:/nix/store/l28zjkflzlydmdqwh32a81krj7vn3xgh-quake3-icculus-1.33pre526]$ ls -l
total 3080
drwxr-xr-x  2 eelco users    4096 2006-01-26 15:10 baseq3
-rw-r--r--  1 eelco users    5529 2006-01-26 15:36 botlib.log
-rwxr-xr-x  1 eelco users  685640 2006-01-26 15:09 ioq3ded.i386
-rwxr-xr-x  1 eelco users 1342232 2006-01-26 15:09 ioquake3.i386
lrwxrwxrwx  1 eelco users      19 2006-01-26 15:18 libGL.so.1 -> /usr/lib/libGL.so.1
lrwxrwxrwx  1 eelco users      23 2006-01-26 15:19 libGLcore.so.1 -> /usr/lib/libGLcore.so.1
lrwxrwxrwx  1 eelco users      30 2006-01-26 15:24 libXcursor.so.1 -> /usr/X11R6/lib/libXcursor.so.1
lrwxrwxrwx  1 eelco users      27 2006-01-26 15:34 libnvidia-tls.so.1 -> /usr/lib/libnvidia-tls.so.1
-rw-r--r--  1 eelco users 1093352 2006-01-26 15:21 log
drwxr-xr-x  2 eelco users    4096 2006-01-26 15:09 missionpack

Then do: LD_LIBRARY_PATH=. ./ioquake3.i386

Need to put this in a wrapper.

Idem for adding the various *.pak files.

On i915:

LD_LIBRARY_PATH=/usr/X11R6/lib/modules/:/nix/store/9gy5fj9x7yvs72y31bm8db7mkl43br8w-libX11-1.0.0/lib:/nix/store/kcbq0frclmskk6mslzcc2qll2ky9l3y0-libXext-1.0.0/lib:/nix/store/54l9jk6l7papbh42z7sjdy1x84m255la-libXp-1.0.0/lib:. ./result/ioquake3.i386 +set fs_basepath ./x

With symlinks for: libexpat.so.0 libGL.so.1 libXxf86vm.so.1

Note that the libGL.so.1 for i915 dynamically loads
/usr/X11R6/lib/modules/dri/i915_dri.so (which depends on
libexpat.so).

*/

stdenv.mkDerivation {
  name = "quake3-icculus-1.33pre526";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/quake3-icculus-r526.tar.bz2;
    md5 = "63429347b918052c27cdb5c1d15939ad";
  };
  builder = ./builder.sh;
  buildInputs = [x11 SDL mesa openal];
}
