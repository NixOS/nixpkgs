source $stdenv/setup

configureFlags="--prefix=$out --exec-prefix=$out"

#TODO: Check also for their dependencies...

if test "$pie"; then
    configureFlags="--enable-pie $configureFlags"
fi

if test "$socketWrapper"; then
    configureFlags="--enable-socket-wrapper $configureFlags"
fi

if test "$cups"; then
    configureFlags="--enable-cups $configureFlags"
fi

if test "$iprint"; then
    configureFlags="--enable-iprint $configureFlags"
fi

if test "$activeDirectory"; then
    configureFlags=" $configureFlags"
fi

ensureDir $stateDir
echo "Building samba with statedir: $stateDir"
sleep 2
configureFlags="$configureFlags --sharedstatedir=$stateDir/shared --localstatedir=$stateDir/localstate --with-configdir=$stateDir/config"

#Copy the default conf file to the state dir
configdir=$stateDir/config
if ! test -d $configdir ; then
   mkdir -p $configdir
fi

echo "configuring with: $configureFlags"
sleep 4

tar -zxvf $src
cd samba-*/source/
./configure $configureFlags
make
make install

cp -f $smbconf $stateDir/config/smb.conf

ensureDir $stateDir/sambalog/
touch $stateDir/sambalog/log.smbd
