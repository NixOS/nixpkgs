source $stdenv/setup

set -o pipefail

PATH=$module_init_tools/sbin:$PATH

version=$(cd $kernel/lib/modules && ls -d *)

echo "kernel version is $version"

export MODULE_DIR=$kernel/lib/modules/

# Determine the dependencies of each root module.
closure=
for module in $rootModules; do
    echo "root module: $module"
    deps=$(modprobe --set-version "$version" --show-depends "$module" \
        | sed 's/^insmod //')
    for i in $deps; do echo $i; done
    closure="$closure $deps"
done

# Remove duplicates.
closure=$(for i in $closure; do echo $i; done | sort | uniq)

echo "closure:"
ensureDir $out
for module in $closure; do
    echo $module
    target=$(echo $module | sed "s^$kernel^$out^")
    mkdir -p $(dirname $target)
    cp $module $target
    grep "^$module" $kernel/lib/modules/$version/modules.dep \
        | sed "s^$kernel^$out^g" \
        >> $out/lib/modules/$version/modules.dep
done

