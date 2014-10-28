addSGMLCatalogs () {
      if test -d $1/sgml/dtd; then
          for i in $(find $1/sgml/dtd -name docbook.cat); do
              export SGML_CATALOG_FILES="${SGML_CATALOG_FILES:+:}$i"
          done
      fi
}

if test -z "$sgmlHookDone"; then
    sgmlHookDone=1

    export SGML_CATALOG_FILES
    envHooks=(${envHooks[@]} addSGMLCatalogs)
fi
