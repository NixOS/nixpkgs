source $stdenv/setup

outp=$out/lib/steam-runtime

buildDir() {
  paths="$1"
  pkgs="$2"

  for pkg in $pkgs; do
    echo "adding package $pkg"
    for path in $paths; do
      if [ -d $pkg/$path ]; then
        cd $pkg/$path
        for file in *; do
          found=""
          for i in $paths; do
            if [ -e "$outp/$i/$file" ]; then
              found=1
              break
            fi
          done
          if [ -z "$found" ]; then
            mkdir -p $outp/$path
            ln -s "$pkg/$path/$file" $outp/$path
            sovers=$(echo $file | perl -ne 'print if s/.*?\.so\.(.*)/\1/')
            if [ ! -z "$sovers" ]; then
              fname=''${file%.''${sovers}}
              for ver in ''${sovers//./ }; do
                found=""
                for i in $paths; do
                  if [ -e "$outp/$i/$fname" ]; then
                    found=1
                    break
                  fi
                done
                [ -n "$found" ] || ln -s "$pkg/$path/$file" "$outp/$path/$fname"
                fname="$fname.$ver"
              done
            fi
          fi
        done
      fi
    done
  done
}

eval "$installPhase"
