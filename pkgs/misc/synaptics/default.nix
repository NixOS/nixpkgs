args: with args;
stdenv.mkDerivation {
  name = "synaptics-0.14.6";

  src = fetchurl {
    url = http://web.telia.com/~u89404340/touchpad/files/synaptics-0.14.6.tar.bz2;
    md5 = "1102cd575045640a064ab6f9b1e391af";
  };

  preBuild = "export NIX_CFLAGS_COMPILE=\"\${NIX_CFLAGS_COMPILE} -I${pixman}/include/pixman-1\";
  	sed -e '/local-[>]motion_history_proc/d; /local-[>]history_size/d;' -i synaptics.c
	sed -e '/ALLINCLUDES = /iX_INCLUDES_ROOT = /homeless-shelter' -i Makefile
	sed -e 's@^CFLAGS =.*@& -DDBG=//@' -i Makefile
	sed -e 's/miPointerGetMotionBufferSize()/&,2/' -i synaptics.c
	sed -e 's/miPointerGetMotionEvents/GetMotionHistory/' -i synaptics.c
	sed -e 's/miPointerGetMotionBufferSize/GetMotionHistorySize/' -i synaptics.c
	";
  makeFlags="DESTDIR=\${out} PREFIX=/ ";
  buildInputs = [libX11 pkgconfig xorgserver libXi libXext pixman xf86inputevdev];

  meta = {
    description = "Driver for synaptics touchpad.";
  };
}
