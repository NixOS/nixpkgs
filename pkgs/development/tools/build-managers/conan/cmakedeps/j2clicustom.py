def j2_environment(env):
    """ Modify the context and return it """
    # An extra variable'
    import os
    pkg = os.environ['pkg_name']
    target_aliases={}
    alias_parts_env = os.environ.get('cmake_aliases', '')
    if alias_parts_env:
        target_aliases={v: f'{pkg}::{pkg}' for v in alias_parts_env.split(',')}

    include_paths = [
        f"{os.environ['out']}/include"
    ]
    extra_includes = os.environ.get('extra_includes')
    if extra_includes:
        include_paths += [os.environ['out'] + '/' + inc for inc in extra_includes.split(" ")]

    global_cpp={
        "build_modules_paths": "",
        "include_paths": " ".join(include_paths),
        "res_paths": "",
        "defines": "",
        "sharedlinkflags_list": "",
        "exelinkflags_list": "",
        "objects_list": "",
        "compile_definitions": "",
        "cflags_list": "",
        "cxxflags_list": "",
        "lib_paths": f"{os.environ['out']}/lib",
        "libs": os.environ.get('conan_lib_search', ''),
        "system_libs": "",
        "framework_paths": "",
        "frameworks": "",
        "build_paths": "",
    }
    env.globals.update(cmake_target_aliases=target_aliases,cmake_component_target_aliases={}, deps_targets_names="",
    components_names=None, set_interface_link_directories=True,
    dependency_filenames=[], dependency_find_modes={},global_cpp=global_cpp)
    return env
