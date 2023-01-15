if (CMAKE_VERSION GREATER_EQUAL 3.19)
  set(QTC_COMMAND_ERROR_IS_FATAL COMMAND_ERROR_IS_FATAL ANY)
endif()

if (CMAKE_VERSION VERSION_LESS 3.18)
  if (CMAKE_CXX_COMPILER_ID STREQUAL GNU)
    set(BUILD_WITH_PCH OFF CACHE BOOL "" FORCE)
  endif()
endif()

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  include(CheckLinkerFlag)
endif()

include(FeatureSummary)

#
# Default Qt compilation defines
#

list(APPEND DEFAULT_DEFINES
  QT_CREATOR
  QT_NO_JAVA_STYLE_ITERATORS
  QT_NO_CAST_TO_ASCII QT_RESTRICTED_CAST_FROM_ASCII
  QT_DISABLE_DEPRECATED_BEFORE=0x050900
  QT_USE_QSTRINGBUILDER
)

if (WIN32)
  list(APPEND DEFAULT_DEFINES UNICODE _UNICODE _CRT_SECURE_NO_WARNINGS)

  if (NOT BUILD_WITH_PCH)
    # Windows 8 0x0602
    list(APPEND DEFAULT_DEFINES
      WINVER=0x0602 _WIN32_WINNT=0x0602
      WIN32_LEAN_AND_MEAN)
  endif()
endif()

#
# Setup path handling
#

if (APPLE)
  set(_IDE_APP_PATH ".")
  set(_IDE_APP_TARGET "${IDE_DISPLAY_NAME}")

  set(_IDE_OUTPUT_PATH "${_IDE_APP_TARGET}.app/Contents")

  set(_IDE_LIBRARY_BASE_PATH "Frameworks")
  set(_IDE_LIBRARY_PATH "${_IDE_OUTPUT_PATH}/${_IDE_LIBRARY_BASE_PATH}")
  set(_IDE_PLUGIN_PATH "${_IDE_OUTPUT_PATH}/PlugIns")
  set(_IDE_LIBEXEC_PATH "${_IDE_OUTPUT_PATH}/Resources/libexec")
  set(_IDE_DATA_PATH "${_IDE_OUTPUT_PATH}/Resources")
  set(_IDE_DOC_PATH "${_IDE_OUTPUT_PATH}/Resources/doc")
  set(_IDE_BIN_PATH "${_IDE_OUTPUT_PATH}/MacOS")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_LIBRARY_PATH}")

  set(_IDE_HEADER_INSTALL_PATH "${_IDE_DATA_PATH}/Headers/qtcreator")
  set(_IDE_CMAKE_INSTALL_PATH "${_IDE_DATA_PATH}/lib/cmake")
elseif(WIN32)
  set(_IDE_APP_PATH "bin")
  set(_IDE_APP_TARGET "${IDE_ID}")

  set(_IDE_LIBRARY_BASE_PATH "lib")
  set(_IDE_LIBRARY_PATH "${_IDE_LIBRARY_BASE_PATH}/qtcreator")
  set(_IDE_PLUGIN_PATH "${_IDE_LIBRARY_BASE_PATH}/qtcreator/plugins")
  set(_IDE_LIBEXEC_PATH "bin")
  set(_IDE_DATA_PATH "share/qtcreator")
  set(_IDE_DOC_PATH "share/doc/qtcreator")
  set(_IDE_BIN_PATH "bin")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_BIN_PATH}")

  set(_IDE_HEADER_INSTALL_PATH "include/qtcreator")
  set(_IDE_CMAKE_INSTALL_PATH "lib/cmake")
else ()
  include(GNUInstallDirs)
  set(_IDE_APP_PATH "${CMAKE_INSTALL_BINDIR}")
  set(_IDE_APP_TARGET "${IDE_ID}")

  set(_IDE_LIBRARY_BASE_PATH "${CMAKE_INSTALL_LIBDIR}")
  set(_IDE_LIBRARY_PATH "${_IDE_LIBRARY_BASE_PATH}/qtcreator")
  set(_IDE_PLUGIN_PATH "${_IDE_LIBRARY_BASE_PATH}/qtcreator/plugins")
  set(_IDE_LIBEXEC_PATH "${CMAKE_INSTALL_LIBEXECDIR}/qtcreator")
  set(_IDE_DATA_PATH "${CMAKE_INSTALL_DATAROOTDIR}/qtcreator")
  set(_IDE_DOC_PATH "${CMAKE_INSTALL_DATAROOTDIR}/doc/qtcreator")
  set(_IDE_BIN_PATH "${CMAKE_INSTALL_BINDIR}")
  message("QtCreatorAPIInternal.cmake: CMAKE_INSTALL_BINDIR=${_IDE_BIN_PATH}")
  message("QtCreatorAPIInternal.cmake: CMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}")
  message("QtCreatorAPIInternal.cmake: CMAKE_INSTALL_LIBEXECDIR=${CMAKE_INSTALL_LIBEXECDIR}")
  message("QtCreatorAPIInternal.cmake: CMAKE_INSTALL_DATAROOTDIR=${CMAKE_INSTALL_DATAROOTDIR}")
  set(_IDE_LIBRARY_ARCHIVE_PATH "${_IDE_LIBRARY_PATH}")

  set(_IDE_HEADER_INSTALL_PATH "include/qtcreator")
  set(_IDE_CMAKE_INSTALL_PATH "${_IDE_LIBRARY_BASE_PATH}/cmake")
endif ()

file(RELATIVE_PATH _PLUGIN_TO_LIB "/${_IDE_PLUGIN_PATH}" "/${_IDE_LIBRARY_PATH}")
file(RELATIVE_PATH _PLUGIN_TO_QT "/${_IDE_PLUGIN_PATH}" "/${_IDE_LIBRARY_BASE_PATH}/Qt/lib")
file(RELATIVE_PATH _LIB_TO_QT "/${_IDE_LIBRARY_PATH}" "/${_IDE_LIBRARY_BASE_PATH}/Qt/lib")

if (APPLE)
  set(_RPATH_BASE "@executable_path")
  set(_LIB_RPATH "@loader_path")
  set(_PLUGIN_RPATH "@loader_path;@loader_path/${_PLUGIN_TO_LIB}")
elseif (WIN32)
  set(_RPATH_BASE "")
  set(_LIB_RPATH "")
  set(_PLUGIN_RPATH "")
else()
  set(_RPATH_BASE "\$ORIGIN")
  set(_LIB_RPATH "\$ORIGIN;\$ORIGIN/${_LIB_TO_QT}")
  set(_PLUGIN_RPATH "\$ORIGIN;\$ORIGIN/${_PLUGIN_TO_LIB};\$ORIGIN/${_PLUGIN_TO_QT}")
endif ()

set(__QTC_PLUGINS "" CACHE INTERNAL "*** Internal ***")
set(__QTC_LIBRARIES "" CACHE INTERNAL "*** Internal ***")
set(__QTC_EXECUTABLES "" CACHE INTERNAL "*** Internal ***")
set(__QTC_TESTS "" CACHE INTERNAL "*** Internal ***")
set(__QTC_RESOURCE_FILES "" CACHE INTERNAL "*** Internal ***")

# handle SCCACHE hack
# SCCACHE does not work with the /Zi option, which makes each compilation write debug info
# into the same .pdb file - even with /FS, which usually makes this work in the first place.
# Replace /Zi with /Z7, which leaves the debug info in the object files until link time.
# This increases memory usage, disk space usage and linking time, so should only be
# enabled if necessary.
# Must be called after project(...).
function(qtc_handle_compiler_cache_support)
  if (WITH_SCCACHE_SUPPORT OR WITH_CCACHE_SUPPORT)
    if (MSVC)
      foreach(config DEBUG RELWITHDEBINFO)
        foreach(lang C CXX)
          set(flags_var "CMAKE_${lang}_FLAGS_${config}")
          string(REPLACE "/Zi" "/Z7" ${flags_var} "${${flags_var}}")
          set(${flags_var} "${${flags_var}}" PARENT_SCOPE)
        endforeach()
      endforeach()
    endif()
  endif()
  if (WITH_CCACHE_SUPPORT)
    find_program(CCACHE_PROGRAM ccache)
    if(CCACHE_PROGRAM)
      set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "CXX compiler launcher" FORCE)
      set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "C compiler launcher" FORCE)
    endif()
  endif()
endfunction()

function(qtc_link_with_qt)
  # When building with Qt Creator 4.15+ do the "Link with Qt..." automatically
  if (BUILD_LINK_WITH_QT AND DEFINED CMAKE_PROJECT_INCLUDE_BEFORE)
    get_filename_component(auto_setup_dir "${CMAKE_PROJECT_INCLUDE_BEFORE}" DIRECTORY)
    set(qt_creator_ini "${auto_setup_dir}/../QtProject/QtCreator.ini")
    if (EXISTS "${qt_creator_ini}")
      file(STRINGS "${qt_creator_ini}" install_settings REGEX "^InstallSettings=.*$")
      if (install_settings)
        string(REPLACE "InstallSettings=" "" install_settings "${install_settings}")
      else()
        file(TO_CMAKE_PATH "${auto_setup_dir}/.." install_settings)
      endif()
      file(WRITE ${CMAKE_BINARY_DIR}/${_IDE_DATA_PATH}/QtProject/QtCreator.ini
                 "[Settings]\nInstallSettings=${install_settings}")
    endif()
  endif()
endfunction()

function(qtc_enable_release_for_debug_configuration)
  if (MSVC)
    string(REPLACE "/Od" "/O2" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
    string(REPLACE "/Ob0" "/Ob1" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
    string(REPLACE "/RTC1" ""  CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
  else()
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O2")
  endif()
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}" PARENT_SCOPE)
endfunction()

function(qtc_enable_sanitize _target _sanitize_flags)
  target_compile_options("${_target}" PUBLIC -fsanitize=${SANITIZE_FLAGS})

  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_link_options("${_target}" PUBLIC -fsanitize=${SANITIZE_FLAGS})
  endif()
endfunction()

function(qtc_add_link_flags_no_undefined target)
  # needs CheckLinkerFlags
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
    set(no_undefined_flag "-Wl,--no-undefined")
    check_linker_flag(CXX ${no_undefined_flag} QTC_LINKER_SUPPORTS_NO_UNDEFINED)
    if (NOT QTC_LINKER_SUPPORTS_NO_UNDEFINED)
        set(no_undefined_flag "-Wl,-undefined,error")
        check_linker_flag(CXX ${no_undefined_flag} QTC_LINKER_SUPPORTS_UNDEFINED_ERROR)
        if (NOT QTC_LINKER_SUPPORTS_UNDEFINED_ERROR)
            return()
        endif()
    endif()
    target_link_options("${target}" PRIVATE "${no_undefined_flag}")
  endif()
endfunction()

function(append_extra_translations target_name)
  if(NOT ARGN)
    return()
  endif()

  if(TARGET "${target_name}")
    get_target_property(_input "${target_name}" QT_EXTRA_TRANSLATIONS)
    if (_input)
      set(_output "${_input}" "${ARGN}")
    else()
      set(_output "${ARGN}")
    endif()
    set_target_properties("${target_name}" PROPERTIES QT_EXTRA_TRANSLATIONS "${_output}")
  endif()
endfunction()

function(update_cached_list name value)
  set(_tmp_list "${${name}}")
  list(APPEND _tmp_list "${value}")
  set("${name}" "${_tmp_list}" CACHE INTERNAL "*** Internal ***")
endfunction()

function(set_explicit_moc target_name file)
  unset(file_dependencies)
  if (file MATCHES "^.*plugin.h$")
    set(file_dependencies DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${target_name}.json")
  endif()
  set_property(SOURCE "${file}" PROPERTY SKIP_AUTOMOC ON)
  qt5_wrap_cpp(file_moc "${file}" ${file_dependencies})
  target_sources(${target_name} PRIVATE "${file_moc}")
endfunction()

function(set_public_headers target sources)
  foreach(source IN LISTS sources)
    if (source MATCHES "\.h$|\.hpp$")
      qtc_add_public_header(${source})
    endif()
  endforeach()
endfunction()

function(update_resource_files_list sources)
  foreach(source IN LISTS sources)
    if (source MATCHES "\.qrc$")
      get_filename_component(resource_name ${source} NAME_WE)
      string(REPLACE "-" "_" resource_name ${resource_name})
      update_cached_list(__QTC_RESOURCE_FILES "${resource_name}")
    endif()
  endforeach()
endfunction()

function(set_public_includes target includes)
  foreach(inc_dir IN LISTS includes)
    if (NOT IS_ABSOLUTE ${inc_dir})
      set(inc_dir "${CMAKE_CURRENT_SOURCE_DIR}/${inc_dir}")
    endif()
    file(RELATIVE_PATH include_dir_relative_path ${PROJECT_SOURCE_DIR} ${inc_dir})
    target_include_directories(${target} PUBLIC
      $<BUILD_INTERFACE:${inc_dir}>
      $<INSTALL_INTERFACE:${_IDE_HEADER_INSTALL_PATH}/${include_dir_relative_path}>
    )
  endforeach()
endfunction()

function(finalize_test_setup test_name)
  cmake_parse_arguments(_arg "" "TIMEOUT" "" ${ARGN})
  if (DEFINED _arg_TIMEOUT)
    set(timeout_arg TIMEOUT ${_arg_TIMEOUT})
  else()
    set(timeout_arg)
  endif()
  # Never translate tests:
  set_tests_properties(${name}
    PROPERTIES
      QT_SKIP_TRANSLATION ON
      ${timeout_arg}
  )

  if (WIN32)
    list(APPEND env_path $ENV{PATH})
    list(APPEND env_path ${CMAKE_BINARY_DIR}/${_IDE_PLUGIN_PATH})
    list(APPEND env_path ${CMAKE_BINARY_DIR}/${_IDE_BIN_PATH})
    list(APPEND env_path $<TARGET_FILE_DIR:Qt5::Test>)
    if (TARGET libclang)
        list(APPEND env_path $<TARGET_FILE_DIR:libclang>)
    endif()

    if (TARGET elfutils::elf)
        list(APPEND env_path $<TARGET_FILE_DIR:elfutils::elf>)
    endif()

    string(REPLACE "/" "\\" env_path "${env_path}")
    string(REPLACE ";" "\\;" env_path "${env_path}")

    set_tests_properties(${test_name} PROPERTIES ENVIRONMENT "PATH=${env_path}")
  endif()
endfunction()

function(check_qtc_disabled_targets target_name dependent_targets)
  foreach(dependency IN LISTS ${dependent_targets})
    foreach(type PLUGIN LIBRARY)
      string(TOUPPER "BUILD_${type}_${dependency}" build_target)
      if (DEFINED ${build_target} AND NOT ${build_target})
        message(SEND_ERROR "Target ${name} depends on ${dependency} which was disabled via ${build_target} set to ${${build_target}}")
      endif()
    endforeach()
  endforeach()
endfunction()

function(add_qtc_depends target_name)
  cmake_parse_arguments(_arg "" "" "PRIVATE;PUBLIC" ${ARGN})
  if (${_arg_UNPARSED_ARGUMENTS})
    message(FATAL_ERROR "add_qtc_depends had unparsed arguments")
  endif()

  check_qtc_disabled_targets(${target_name} _arg_PRIVATE)
  check_qtc_disabled_targets(${target_name} _arg_PUBLIC)

  set(depends "${_arg_PRIVATE}")
  set(public_depends "${_arg_PUBLIC}")

  get_target_property(target_type ${target_name} TYPE)
  if (NOT target_type STREQUAL "OBJECT_LIBRARY")
    target_link_libraries(${target_name} PRIVATE ${depends} PUBLIC ${public_depends})
  else()
    list(APPEND object_lib_depends ${depends})
    list(APPEND object_public_depends ${public_depends})
  endif()

  foreach(obj_lib IN LISTS object_lib_depends)
    target_compile_options(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_OPTIONS>)
    target_compile_definitions(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_DEFINITIONS>)
    target_include_directories(${target_name} PRIVATE $<TARGET_PROPERTY:${obj_lib},INTERFACE_INCLUDE_DIRECTORIES>)
  endforeach()
  foreach(obj_lib IN LISTS object_public_depends)
    target_compile_options(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_OPTIONS>)
    target_compile_definitions(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_COMPILE_DEFINITIONS>)
    target_include_directories(${target_name} PUBLIC $<TARGET_PROPERTY:${obj_lib},INTERFACE_INCLUDE_DIRECTORIES>)
  endforeach()
endfunction()

function(find_dependent_plugins varName)
  set(_RESULT ${ARGN})

  foreach(i ${ARGN})
    if(NOT TARGET ${i})
      continue()
    endif()
    set(_dep)
    get_property(_dep TARGET "${i}" PROPERTY _arg_DEPENDS)
    if (_dep)
      find_dependent_plugins(_REC ${_dep})
      list(APPEND _RESULT ${_REC})
    endif()
  endforeach()

  if (_RESULT)
    list(REMOVE_DUPLICATES _RESULT)
    list(SORT _RESULT)
  endif()

  set("${varName}" ${_RESULT} PARENT_SCOPE)
endfunction()

function(enable_pch target)
  if (BUILD_WITH_PCH)
    # Skip PCH for targets that do not use the expected visibility settings:
    get_target_property(visibility_property "${target}" CXX_VISIBILITY_PRESET)
    get_target_property(inlines_property "${target}" VISIBILITY_INLINES_HIDDEN)

    if (NOT visibility_property STREQUAL "hidden" OR NOT inlines_property)
      return()
    endif()

    # static libs are maybe used by other projects, so they can not reuse same pch files
    if (MSVC)
        get_target_property(target_type "${target}" TYPE)
        if (target_type MATCHES "STATIC")
            return()
        endif()
    endif()

    # Skip PCH for targets that do not have QT_NO_CAST_TO_ASCII
    get_target_property(target_defines "${target}" COMPILE_DEFINITIONS)
    if (NOT "QT_NO_CAST_TO_ASCII" IN_LIST target_defines)
      return()
    endif()

    get_target_property(target_type ${target} TYPE)
    if (NOT ${target_type} STREQUAL "OBJECT_LIBRARY")
      function(_recursively_collect_dependencies input_target)
        get_target_property(input_type ${input_target} TYPE)
        if (${input_type} STREQUAL "INTERFACE_LIBRARY")
          set(prefix "INTERFACE_")
        endif()
        get_target_property(link_libraries ${input_target} ${prefix}LINK_LIBRARIES)
        foreach(library IN LISTS link_libraries)
          if(TARGET ${library} AND NOT ${library} IN_LIST dependencies)
            list(APPEND dependencies ${library})
            _recursively_collect_dependencies(${library})
          endif()
        endforeach()
        set(dependencies ${dependencies} PARENT_SCOPE)
      endfunction()
      _recursively_collect_dependencies(${target})

      function(_add_pch_target pch_target pch_file pch_dependency)
        if (EXISTS ${pch_file})
          add_library(${pch_target} STATIC
            ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.cpp
            ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.c)
          target_compile_definitions(${pch_target} PRIVATE ${DEFAULT_DEFINES})
          set_target_properties(${pch_target} PROPERTIES
            PRECOMPILE_HEADERS ${pch_file}
            CXX_VISIBILITY_PRESET hidden
            VISIBILITY_INLINES_HIDDEN ON
            CXX_EXTENSIONS OFF
          )
          target_link_libraries(${pch_target} PRIVATE ${pch_dependency})
        endif()
      endfunction()

      if (NOT TARGET ${PROJECT_NAME}PchGui AND NOT TARGET ${PROJECT_NAME}PchConsole)
        file(GENERATE
          OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.c
          CONTENT "/*empty file*/")
        file(GENERATE
          OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.cpp
          CONTENT "/*empty file*/")
        set_source_files_properties(
            ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.c
            ${CMAKE_CURRENT_BINARY_DIR}/empty_pch.cpp
            PROPERTIES GENERATED TRUE)

        _add_pch_target(${PROJECT_NAME}PchGui
          "${QtCreator_SOURCE_DIR}/src/shared/qtcreator_gui_pch.h" Qt5::Widgets)
        _add_pch_target(${PROJECT_NAME}PchConsole
          "${QtCreator_SOURCE_DIR}/src/shared/qtcreator_pch.h" Qt5::Core)
      endif()

      unset(PCH_TARGET)
      if ("Qt5::Widgets" IN_LIST dependencies)
        set(PCH_TARGET ${PROJECT_NAME}PchGui)
      elseif ("Qt5::Core" IN_LIST dependencies)
        set(PCH_TARGET ${PROJECT_NAME}PchConsole)
      endif()

      if (TARGET "${PCH_TARGET}")
        set_target_properties(${target} PROPERTIES
          PRECOMPILE_HEADERS_REUSE_FROM ${PCH_TARGET})
      endif()
    endif()
  endif()
endfunction()

function(condition_info varName condition)
  if (NOT ${condition})
    set(${varName} "" PARENT_SCOPE)
  else()
    string(REPLACE ";" " " _contents "${${condition}}")
    set(${varName} "with CONDITION ${_contents}" PARENT_SCOPE)
  endif()
endfunction()

function(extend_qtc_target target_name)
  cmake_parse_arguments(_arg
    ""
    "SOURCES_PREFIX;SOURCES_PREFIX_FROM_TARGET;FEATURE_INFO"
    "CONDITION;DEPENDS;PUBLIC_DEPENDS;DEFINES;PUBLIC_DEFINES;INCLUDES;PUBLIC_INCLUDES;SOURCES;EXPLICIT_MOC;SKIP_AUTOMOC;EXTRA_TRANSLATIONS;PROPERTIES"
    ${ARGN}
  )

  if (${_arg_UNPARSED_ARGUMENTS})
    message(FATAL_ERROR "extend_qtc_target had unparsed arguments")
  endif()

  condition_info(_extra_text _arg_CONDITION)
  if (NOT _arg_CONDITION)
    set(_arg_CONDITION ON)
  endif()
  if (${_arg_CONDITION})
    set(_feature_enabled ON)
  else()
    set(_feature_enabled OFF)
  endif()
  if (_arg_FEATURE_INFO)
    add_feature_info(${_arg_FEATURE_INFO} _feature_enabled "${_extra_text}")
  endif()
  if (NOT _feature_enabled)
    return()
  endif()

  if (_arg_SOURCES_PREFIX_FROM_TARGET)
    if (NOT TARGET ${_arg_SOURCES_PREFIX_FROM_TARGET})
      return()
    else()
      get_target_property(_arg_SOURCES_PREFIX ${_arg_SOURCES_PREFIX_FROM_TARGET} SOURCES_DIR)
    endif()
  endif()

  add_qtc_depends(${target_name}
    PRIVATE ${_arg_DEPENDS}
    PUBLIC ${_arg_PUBLIC_DEPENDS}
  )
  target_compile_definitions(${target_name}
    PRIVATE ${_arg_DEFINES}
    PUBLIC ${_arg_PUBLIC_DEFINES}
  )
  target_include_directories(${target_name} PRIVATE ${_arg_INCLUDES})

  set_public_includes(${target_name} "${_arg_PUBLIC_INCLUDES}")

  if (_arg_SOURCES_PREFIX)
    foreach(source IN LISTS _arg_SOURCES)
      list(APPEND prefixed_sources "${_arg_SOURCES_PREFIX}/${source}")
    endforeach()

    if (NOT IS_ABSOLUTE ${_arg_SOURCES_PREFIX})
      set(_arg_SOURCES_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/${_arg_SOURCES_PREFIX}")
    endif()
    target_include_directories(${target_name} PRIVATE $<BUILD_INTERFACE:${_arg_SOURCES_PREFIX}>)

    set(_arg_SOURCES ${prefixed_sources})
  endif()
  target_sources(${target_name} PRIVATE ${_arg_SOURCES})

  if (APPLE AND BUILD_WITH_PCH)
    foreach(source IN LISTS _arg_SOURCES)
      if (source MATCHES "^.*\.mm$")
        set_source_files_properties(${source} PROPERTIES SKIP_PRECOMPILE_HEADERS ON)
      endif()
    endforeach()
  endif()

  set_public_headers(${target_name} "${_arg_SOURCES}")
  update_resource_files_list("${_arg_SOURCES}")

  foreach(file IN LISTS _arg_EXPLICIT_MOC)
    set_explicit_moc(${target_name} "${file}")
  endforeach()

  foreach(file IN LISTS _arg_SKIP_AUTOMOC)
    set_property(SOURCE ${file} PROPERTY SKIP_AUTOMOC ON)
  endforeach()

  append_extra_translations(${target_name} "${_arg_EXTRA_TRANSLATIONS}")

  if (_arg_PROPERTIES)
    set_target_properties(${target_name} PROPERTIES ${_arg_PROPERTIES})
  endif()
endfunction()
