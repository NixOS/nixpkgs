/* Some functions for manipulating meta attributes, as well as the
   name attribute. */

rec {


  /* Add to or override the meta attributes of the given
     derivation.

     Example:
       addMetaAttrs {description = "Bla blah";} somePkg
  */
  addMetaAttrs = newAttrs: drv:
    drv // { meta = (if drv ? meta then drv.meta else {}) // newAttrs; };


  /* Change the symbolic name of a package for presentation purposes
     (i.e., so that nix-env users can tell them apart).
  */
  setName = name: drv: drv // {inherit name;};


  /* Like `setName', but takes the previous name as an argument.

     Example:
       updateName (oldName: oldName + "-experimental") somePkg
  */
  updateName = updater: drv: drv // {name = updater (drv.name);};


  /* Append a suffix to the name of a package.  !!! the suffix should
     really be appended *before* the version, at least most of the
     time.
  */
  appendToName = suffix: updateName (name: "${name}-${suffix}");


  /* Decrease the nix-env priority of the package, i.e., other
     versions/variants of the package will be preferred.
  */
  lowPrio = drv: addMetaAttrs { priority = "10"; } drv;

  /* Increase the nix-env priority of the package, i.e., this
     version/variant of the package will be preferred.
  */
  hiPrio = drv: addMetaAttrs { priority = "-10"; } drv;
  
}
