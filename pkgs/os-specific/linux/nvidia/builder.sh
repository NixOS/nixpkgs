source $stdenv/setup

echo "Building linux driver against kernel: " $kernelOutPath;
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

echo $nvidiasrc
cp $nvidiasrc .
chmod 755 ./*-NVIDIA*
./*-NVIDIA* -x
cd NVIDIA*/

cd usr/src/nv/
pwd -P

#Clean up
#make clean

#Create the module
echo $out
mkdir $out
make SYSSRC=$kernelOutPath/lib/modules/2.*/build/ module	

#go to the usr dir of the nvidia package
cd ../../

echo "Copying all files to " $out/lib""

cp -R * $out

#add extra symlinks in $out
ln -sf $out/lib/libGLcore.so.1.0.9755 $out/lib/libGLcore.so
ln -sf $out/lib/libGLcore.so.1.0.9755 $out/lib/libGLcore.so.1
ln -sf $out/lib/libGL.so.1.0.9755 $out/lib/libGL.so
ln -sf $out/lib/libGL.so.1.0.9755 $out/lib/libGL.so.1
ln -sf $out/lib/libnvidia-cfg.so.1.0.9755 $out/lib/libnvidia-cfg.so.1
ln -sf $out/lib/libnvidia-tls.so.1.0.9755 $out/lib/libnvidia-tls.so.1
ln -sf $out/X11R6/lib/libXvMCNVIDIA.so.1.0.9755 $out/X11R6/lib/libXvMCNVIDIA.so.1
ln -sf $out/X11R6/lib/libXvMCNVIDIA.so.1.0.9755 $out/lib/libXvMCNVIDIA.so.1
ln -sf $out/X11R6/lib/modules/libnvidia-wfb.so.1.0.9755 $out/X11R6/lib/modules/libnvidia-wfb.so.1
ln -sf $out/X11R6/lib/modules/libnvidia-wfb.so.1.0.9755 $out/lib/libnvidia-wfb.so.1
ln -sf $out/X11R6/lib/modules/extensions/libglx.so.1.0.9755 $out/X11R6/lib/modules/extensions/libglx.so.1
ln -sf $out/X11R6/lib/modules/extensions/libglx.so.1.0.9755 $out/lib/libglx.so.1

#TODO: patchelf binaries !
#patchelf --set-interpreter ${path glibc TODO  /lib/ld-linux.so.2 $out/bin/....

#from dep on xorg-sys-opengl: add symlinks in /usr/lib/ (especially libGL.so.1) to the real location...

ensureDir /usr/lib/
cd /usr/lib
ln -sf $out/lib/libGLcore.so.1.* libGLcore.so.1
ln -sf $out/lib/libGL.la libGL.la
ln -sf $out/lib/libGL.so.1.* libGL.so.1
ln -sf $out/lib/libnvidia-cfg.so.1.* libnvidia-cfg.so.1
ln -sf $out/lib/libnvidia-tls.so.1.* libnvidia-tls.so.1
ensureDir /usr/lib/tls/
ln -sf $out/lib/tls/libnvidia-tls.so.1.* /usr/lib/tls/libnvidia-tls.so.1
ln -sf $out/X11R6/lib/modules/extensions/libglx.so.1.* libglx.so.1
ln -sf $out/X11R6/lib/modules/libnvidia-wfb.so.1.* libnvidia-wfb.so.1
ln -sf $out/X11R6/lib/modules/drivers/nvidia_drv.so nvidia_drv.so
ln -sf $out/X11R6/lib/libXvMCNVIDIA.so.1.* libXvMCNVIDIA.so.1
ln -sf $out/bin/tls_test_dso.so tls_test_dso.so
ln -sf $out/src/nv/nvidia.ko nvidia.ko

echo "YOU! need to add symlinks as root to the libs in the current $xorgOutPath/lib/xorg/modules/extensions/     (especially libglx.so)"
rwlibs="
cd $xorgOutPath/lib/xorg/modules/extensions/;
mv libglx.so libglx.so.org;
mv libglx.la libglx.la.org;
mv libGLcore.so libGLcore.so.org;
ln -sf /usr/lib/libglx.so.1 libglx.so;
ln -sf /usr/lib/libglx.so.1 libglx.so.1;
ln -sf /usr/lib/libGLcore.so.1 libGLcore.so;
ln -sf /usr/lib/libGLcore.so.1 libGLcore.so.1;
ln -sf /usr/lib/libGL.so.1 libGL.so;
ln -sf /usr/lib/libGL.so.1 libGL.so.1;
ln -sf /usr/lib/libglx.la libglx.la;
ln -sf /usr/lib/libglx.so.1 libglx.so;
ln -sf /usr/lib/libglx.so.1 libglx.so.1;
ln -sf /usr/lib/nvidia_drv.so nvidia_drv.so;
ln -sf $out/src/nv/nvidia.ko $kernelOutPath/lib/modules/$(uname -r)/kernel/drivers/video/nvidia/nvidia.ko;

"
rwlibsfile="$out/bin/nvidia-rewriteLibs.sh"

echo "--------------------------------------------------------"
echo "YOU MUST RUN $rwlibsfile as ROOT after this installation"
echo "--------------------------------------------------------"
echo $rwlibs > $rwlibsfile
chmod 755 $rwlibsfile

sleep 5

