if test -z "$out"; then
  out="$OUT"
  initialPath="$INITIALPATH"
  shell="$SHELL"
fi

setupPath=
for i in $initialPath; do
  setupPath=$setupPath${setupPath:+:}$i
done

PATH=$setupPath
export PATH

mkdir $out

cat > $out/setup <<EOF
PATH=$setupPath
export PATH

SHELL=$shell
export SHELL

# make fetchurl usable
header() {
  echo "\$1"
}

stopNest() {
  echo "Nothing to do"
}

# !!! Awful copy&paste.
substitute() {
    local input="\$1"
    local output="\$2"

    local -a params=("\$@")

    local sedScript=\$NIX_BUILD_TOP/.sedargs
    rm -f \$sedScript
    touch \$sedScript

    local n p pattern replacement varName
    
    for ((n = 2; n < \${#params[*]}; n += 1)); do
        p=\${params[\$n]}

        if test "\$p" = "--replace"; then
            pattern=\${params[\$((n + 1))]}
            replacement=\${params[\$((n + 2))]}
            n=\$((n + 2))
            echo "s^\$pattern^\$replacement^g" >> \$sedScript
            sedArgs=("\${sedArgs[@]}" "-e" )
        fi

        if test "\$p" = "--subst-var"; then
            varName=\${params[\$((n + 1))]}
            n=\$((n + 1))
            echo "s^@\${varName}@^\${!varName}^g" >> \$sedScript
        fi

        if test "\$p" = "--subst-var-by"; then
            varName=\${params[\$((n + 1))]}
            replacement=\${params[\$((n + 2))]}
            n=\$((n + 2))
            echo "s^@\${varName}@^\$replacement^g" >> \$sedScript
        fi

    done

    sed -f \$sedScript < "\$input" > "\$output".tmp
    if test -x "\$output"; then
        chmod +x "\$output".tmp
    fi
    mv -f "\$output".tmp "\$output"
}
EOF

chmod +x $out/setup
