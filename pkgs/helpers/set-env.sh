addtoenv()
{
    envpkgs="$envpkgs $1"

    if test -d $1/bin; then
        export PATH=$1/bin:$PATH
    fi

    if test -d $1/lib; then
	export NIX_LDFLAGS="-L $1/lib -Wl,-rpath,$1/lib $NIX_LDFLAGS"
    fi

    if test -d $1/lib/pkgconfig; then
        export PKG_CONFIG_PATH=$1/lib/pkgconfig:$PKG_CONFIG_PATH
    fi

    if test -f $1/envpkgs; then
        for i in $(cat $1/envpkgs); do
            addtoenv $i
        done
    fi
}

oldenvpkgs=$envpkgs
envpkgs=

for i in $oldenvpkgs; do
    addtoenv $i
done

export NIX_LDFLAGS="-Wl,-rpath,$out/lib $NIX_LDFLAGS"
