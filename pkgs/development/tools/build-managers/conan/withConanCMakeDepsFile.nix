{ stdenv, lib, symlinkJoin, j2cli }:
{ package, pkg_name ? null, file_name ? null, version ? null, aliases ? [ ], lib_search ? "", extra_includes ? "" }:
symlinkJoin {
  name = package.name;
  paths = [ package ];
  postBuild =
    let
      _pkg_name = if pkg_name != null then pkg_name else package.pname;
      _file_name = if file_name != null then file_name else _pkg_name;
      _version = if version != null then version else package.version;
      pkg_name_lower = lib.strings.toLower _pkg_name;
      root_target = "${pkg_name_lower}::${pkg_name_lower}";
    in
    ''
      if [ -d $out/lib/cmake ]; then
        #ls -al --color=auto $out $out/lib $out/lib/cmake
        rm -rf $out/lib/cmake
        # cp -r --reflink=auto ${package}/lib/ $out/lib/
      fi

      if true || [ ! -f $out/lib/cmake/${_pkg_name}/${_file_name}Config.cmake ]; then

      export extra_includes="${extra_includes}"

      mkdir -p $out/lib/cmake/${_pkg_name}/
      file_name=${_file_name} \
      pkg_name=${_pkg_name} \
      targets_include_file=${_file_name}Targets.cmake \
      version=${_version} \
      config_suffix= \
      check_components_exist=true \
      is_module=false \
      ${j2cli}/bin/j2 ${./cmakedeps/cmake.jinja} -o $out/lib/cmake/${_pkg_name}/${_file_name}Config.cmake
      file_name=${_file_name} \
      pkg_name=${_pkg_name} \
      targets_include_file=${_file_name}Targets.cmake \
      version=${_version} \
      config_suffix= \
      check_components_exist=true \
      is_module=false \
      ${j2cli}/bin/j2 ${./cmakedeps/cmakeversion.jinja} -o $out/lib/cmake/${_pkg_name}/${_file_name}ConfigVersion.cmake


      file_name=${_file_name} \
      pkg_name=${_pkg_name} \
      targets_include_file=${_file_name}Targets.cmake \
      version=${_version} \
      data_pattern='$'{_DIR}/${_file_name}-*-data.cmake \
      target_pattern=${_file_name}-Target-*.cmake \
      root_target_name=${root_target}  \
      config_suffix= \
      check_components_exist=true \
      is_module=false \
      cmake_aliases=${builtins.concatStringsSep "," aliases} \
      ${j2cli}/bin/j2 ${./cmakedeps/cmaketargets.jinja} --customize ${./cmakedeps/j2clicustom.py} -o $out/lib/cmake/${_pkg_name}/${_file_name}Targets.cmake


      file_name=${_file_name} \
      pkg_name=${_pkg_name} \
      targets_include_file=${_file_name}Targets.cmake \
      version=${_version} \
      target_pattern=${_file_name}-Target-*.cmake \
      root_target_name=${root_target}  \
      config=RELEASE \
      configuration=Release \
      config_suffix= \
      check_components_exist=true \
      is_module=false \
      cmake_aliases=${builtins.concatStringsSep "," aliases} \
      ${j2cli}/bin/j2 ${./cmakedeps/cmakerelease.jinja} --customize ${./cmakedeps/j2clicustom.py} -o $out/lib/cmake/${_pkg_name}/${_file_name}-Target-release.cmake

      file_name=${_file_name} \
      pkg_name=${_pkg_name} \
      targets_include_file=${_file_name}Targets.cmake \
      version=${_version} \
      target_pattern=${_file_name}-Target-*.cmake \
      root_target_name=${root_target}  \
      config=RELEASE \
      configuration=Release \
      config_suffix= \
      check_components_exist=true \
      is_module=false \
      package_folder=${package} \
      has_components= \
      conan_lib_search="${lib_search}" \
      cmake_aliases=${builtins.concatStringsSep "," aliases} \
      ${j2cli}/bin/j2 ${./cmakedeps/cmaketargetsdata.jinja} --customize ${./cmakedeps/j2clicustom.py} -o $out/lib/cmake/${_pkg_name}/${_file_name}-release-${stdenv.system}-data.cmake

      echo $out/lib/cmake/${_pkg_name}/${_file_name}Targets.cmake
      cat $out/lib/cmake/${_pkg_name}/${_file_name}Targets.cmake

      fi
    '';
}
