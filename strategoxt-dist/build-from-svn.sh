#! /bin/sh -v

buildinputs="$make $automake $autoconf $libtool $which $withsdf"
. $stdenv/setup || exit 1

echo "pwd = `pwd`"
echo "PATH = $PATH"

# configuration flags

config_flags=""

for pack in `env | grep with | sed "s/^with\([A-Za-z]*\)=.*/\1/"`
do
  config_flags="${config_flags} --with-${pack}=$(printenv with${pack})"
done

for feat in `env | grep enable | sed "s/^enable\([A-Za-z]*\)=.*/\1/"`
do
  config_flags="${config_flags} --enable-${feat}=$(printenv enable${feat})"
done

echo "config_flags : $config_flags"

# keep a log

distdir=$out/www/strategoxt/$version-$rev
logdir=$distdir/log
mkdir -p $distdir || exit 1
mkdir -p $logdir || exit 1

# get the source

cp -r $src src || exit 1
chmod -R +w src
cd src || exit 1

echo ${rev} > svn-revision

# build it

GO="true"

./bootstrap                               2>&1 | tee $logdir/bootstrap.txt
./configure --prefix=$out ${config_flags} 2>&1 | tee $logdir/configure.txt

if ! make install                         2>&1 | tee $logdir/install.txt 
then 
  GO="false"
fi

if test $GO = "true"
then
  if ! make check                         2>&1 | tee $logdir/check.txt
  then 
    GO="false"
  fi
fi

# make a distribution

if test $GO = "true"
then
  if make dist                            2>&1 | tee $logdir/dist.txt
  then
    if test "x${status}" = "xrelease"
    then
      cp ${packagename}-${version}.tar.gz $distdir || exit 1
    else
      tar zxf ${packagename}-${version}.tar.gz
      mv ${packagename}-${version} ${name}
      tar zcf ${name}.tar.gz ${name}
      cp ${name}.tar.gz $distdir || exit 1
    fi
  fi
fi

# distribute documentation data

if test -f news/NEWS-$version
then
  cp news/NEWS-$version $distdir || exit 1
fi

cp NEWS ChangeLog AUTHORS README COPYING $distdir || exit 1
