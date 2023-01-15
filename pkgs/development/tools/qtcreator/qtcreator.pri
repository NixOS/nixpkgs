!isEmpty(QTCREATOR_PRI_INCLUDED):error("qtcreator.pri already included")
QTCREATOR_PRI_INCLUDED = 1

include($$PWD/qtcreator_ide_branding.pri)
!isEmpty(IDE_BRANDING_PRI): include($$IDE_BRANDING_PRI)

include(qtcreator_testvars.pri)

PRODUCT_BUNDLE_IDENTIFIER=$${PRODUCT_BUNDLE_ORGANIZATION}.$${IDE_ID}
VERSION = $$QTCREATOR_VERSION

# include c++1z as an alias for c++17 for compatibility for older Qt versions
# that we use for sdktool
CONFIG += c++17 c++1z

defineReplace(qtLibraryTargetName) {
   unset(LIBRARY_NAME)
   LIBRARY_NAME = $$1
   CONFIG(debug, debug|release) {
      !debug_and_release|build_pass {
          mac:RET = $$member(LIBRARY_NAME, 0)_debug
              else:win32:RET = $$member(LIBRARY_NAME, 0)d
      }
   }
   isEmpty(RET):RET = $$LIBRARY_NAME
   return($$RET)
}

defineReplace(qtLibraryName) {
   RET = $$qtLibraryTargetName($$1)
   win32 {
      VERSION_LIST = $$split(QTCREATOR_VERSION, .)
      RET = $$RET$$first(VERSION_LIST)
   }
   return($$RET)
}

defineTest(minQtVersion) {
    maj = $$1
    min = $$2
    patch = $$3
    isEqual(QT_MAJOR_VERSION, $$maj) {
        isEqual(QT_MINOR_VERSION, $$min) {
            isEqual(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
            greaterThan(QT_PATCH_VERSION, $$patch) {
                return(true)
            }
        }
        greaterThan(QT_MINOR_VERSION, $$min) {
            return(true)
        }
    }
    greaterThan(QT_MAJOR_VERSION, $$maj) {
        return(true)
    }
    return(false)
}

# For use in custom compilers which just copy files
defineReplace(stripSrcDir) {
    return($$relative_path($$absolute_path($$1, $$OUT_PWD), $$_PRO_FILE_PWD_))
}

darwin:!minQtVersion(5, 7, 0) {
    # Qt 5.6 still sets deployment target 10.7, which does not work
    # with all C++11/14 features (e.g. std::future)
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.8
}

isEmpty(IDE_LIBRARY_BASENAME) {
    IDE_LIBRARY_BASENAME = lib
}

equals(TEST, 1) {
    QT +=testlib
    DEFINES += WITH_TESTS
}

IDE_SOURCE_TREE = $$PWD
isEmpty(IDE_BUILD_TREE) {
    sub_dir = $$_PRO_FILE_PWD_
    sub_dir ~= s,^$$re_escape($$PWD),,
    IDE_BUILD_TREE = $$clean_path($$OUT_PWD)
    IDE_BUILD_TREE ~= s,$$re_escape($$sub_dir)$,,
}

IDE_APP_PATH = $$IDE_BUILD_TREE/bin
osx {
    IDE_APP_TARGET   = "$$IDE_DISPLAY_NAME"

    # check if IDE_BUILD_TREE is actually an existing Qt Creator.app,
    # for building against a binary package
    exists($$IDE_BUILD_TREE/Contents/MacOS/$$IDE_APP_TARGET): IDE_APP_BUNDLE = $$IDE_BUILD_TREE
    else: IDE_APP_BUNDLE = $$IDE_APP_PATH/$${IDE_APP_TARGET}.app

    # set output path if not set manually
    isEmpty(IDE_OUTPUT_PATH): IDE_OUTPUT_PATH = $$IDE_APP_BUNDLE/Contents

    IDE_LIBRARY_PATH = $$IDE_OUTPUT_PATH/Frameworks
    IDE_PLUGIN_PATH  = $$IDE_OUTPUT_PATH/PlugIns
    IDE_LIBEXEC_PATH = $$IDE_OUTPUT_PATH/Resources/libexec
    IDE_DATA_PATH    = $$IDE_OUTPUT_PATH/Resources
    IDE_DOC_PATH     = $$IDE_DATA_PATH/doc
    IDE_BIN_PATH     = $$IDE_OUTPUT_PATH/MacOS
    copydata = 1

    LINK_LIBRARY_PATH = $$IDE_APP_BUNDLE/Contents/Frameworks
    LINK_PLUGIN_PATH  = $$IDE_APP_BUNDLE/Contents/PlugIns

    INSTALL_LIBRARY_PATH = $$QTC_PREFIX/$${IDE_APP_TARGET}.app/Contents/Frameworks
    INSTALL_PLUGIN_PATH  = $$QTC_PREFIX/$${IDE_APP_TARGET}.app/Contents/PlugIns
    INSTALL_LIBEXEC_PATH = $$QTC_PREFIX/$${IDE_APP_TARGET}.app/Contents/Resources/libexec
    INSTALL_DATA_PATH    = $$QTC_PREFIX/$${IDE_APP_TARGET}.app/Contents/Resources
    INSTALL_DOC_PATH     = $$INSTALL_DATA_PATH/doc
    INSTALL_BIN_PATH     = $$QTC_PREFIX/$${IDE_APP_TARGET}.app/Contents/MacOS
    INSTALL_APP_PATH     = $$QTC_PREFIX/
} else {
    contains(TEMPLATE, vc.*):vcproj = 1
    IDE_APP_TARGET   = $$IDE_ID

    # target output path if not set manually
    isEmpty(IDE_OUTPUT_PATH): IDE_OUTPUT_PATH = $$IDE_BUILD_TREE

    IDE_LIBRARY_PATH = $$IDE_OUTPUT_PATH/$$IDE_LIBRARY_BASENAME/qtcreator
    IDE_PLUGIN_PATH  = $$IDE_LIBRARY_PATH/plugins
    IDE_DATA_PATH    = $$IDE_OUTPUT_PATH/share/qtcreator
    IDE_DOC_PATH     = $$IDE_OUTPUT_PATH/share/doc/qtcreator
    IDE_BIN_PATH     = $$IDE_OUTPUT_PATH/bin
    win32: \
        IDE_LIBEXEC_PATH = $$IDE_OUTPUT_PATH/bin
    else: \
        IDE_LIBEXEC_PATH = $$IDE_OUTPUT_PATH/libexec/qtcreator
    !isEqual(IDE_SOURCE_TREE, $$IDE_OUTPUT_PATH):copydata = 1

    LINK_LIBRARY_PATH = $$IDE_BUILD_TREE/$$IDE_LIBRARY_BASENAME/qtcreator
    LINK_PLUGIN_PATH  = $$LINK_LIBRARY_PATH/plugins

    INSTALL_LIBRARY_PATH = $$QTC_PREFIX/$$IDE_LIBRARY_BASENAME/qtcreator
    INSTALL_PLUGIN_PATH  = $$INSTALL_LIBRARY_PATH/plugins
    win32: \
        INSTALL_LIBEXEC_PATH = $$QTC_PREFIX/bin
    else: \
        INSTALL_LIBEXEC_PATH = $$QTC_PREFIX/libexec/qtcreator
    INSTALL_DATA_PATH    = $$QTC_PREFIX/share/qtcreator
    INSTALL_DOC_PATH     = $$QTC_PREFIX/share/doc/qtcreator
    INSTALL_BIN_PATH     = $$QTC_PREFIX/bin
    INSTALL_APP_PATH     = $$QTC_PREFIX/bin
}

gcc:!clang: QMAKE_CXXFLAGS += -Wno-noexcept-type

RELATIVE_PLUGIN_PATH = $$relative_path($$IDE_PLUGIN_PATH, $$IDE_BIN_PATH)
RELATIVE_LIBEXEC_PATH = $$relative_path($$IDE_LIBEXEC_PATH, $$IDE_BIN_PATH)
RELATIVE_DATA_PATH = $$relative_path($$IDE_DATA_PATH, $$IDE_BIN_PATH)
RELATIVE_DOC_PATH = $$relative_path($$IDE_DOC_PATH, $$IDE_BIN_PATH)
DEFINES += $$shell_quote(RELATIVE_PLUGIN_PATH=\"$$RELATIVE_PLUGIN_PATH\")
DEFINES += $$shell_quote(RELATIVE_LIBEXEC_PATH=\"$$RELATIVE_LIBEXEC_PATH\")
DEFINES += $$shell_quote(RELATIVE_DATA_PATH=\"$$RELATIVE_DATA_PATH\")
DEFINES += $$shell_quote(RELATIVE_DOC_PATH=\"$$RELATIVE_DOC_PATH\")

INCLUDEPATH += \
    $$IDE_BUILD_TREE/src \ # for <app/app_version.h> in case of actual build directory
    $$IDE_SOURCE_TREE/src \ # for <app/app_version.h> in case of binary package with dev package
    $$IDE_SOURCE_TREE/src/libs \
    $$IDE_SOURCE_TREE/tools

win32:exists($$IDE_SOURCE_TREE/lib/qtcreator) {
    # for .lib in case of binary package with dev package
    LIBS *= -L$$IDE_SOURCE_TREE/lib/qtcreator
    LIBS *= -L$$IDE_SOURCE_TREE/lib/qtcreator/plugins
}

QTC_PLUGIN_DIRS_FROM_ENVIRONMENT = $$(QTC_PLUGIN_DIRS)
QTC_PLUGIN_DIRS += $$split(QTC_PLUGIN_DIRS_FROM_ENVIRONMENT, $$QMAKE_DIRLIST_SEP)
QTC_PLUGIN_DIRS += $$IDE_SOURCE_TREE/src/plugins
for(dir, QTC_PLUGIN_DIRS) {
    INCLUDEPATH += $$dir
}

QTC_LIB_DIRS_FROM_ENVIRONMENT = $$(QTC_LIB_DIRS)
QTC_LIB_DIRS += $$split(QTC_LIB_DIRS_FROM_ENVIRONMENT, $$QMAKE_DIRLIST_SEP)
QTC_LIB_DIRS += $$IDE_SOURCE_TREE/src/libs
QTC_LIB_DIRS += $$IDE_SOURCE_TREE/src/libs/3rdparty
for(dir, QTC_LIB_DIRS) {
    INCLUDEPATH += $$dir
}

CONFIG += \
    depend_includepath \
    no_include_pwd

LIBS *= -L$$LINK_LIBRARY_PATH  # Qt Creator libraries
exists($$IDE_LIBRARY_PATH): LIBS *= -L$$IDE_LIBRARY_PATH  # library path from output path
# linking against Qt Creator built with CMake
win32: LIBS *= -L$$IDE_BUILD_TREE/bin

!isEmpty(vcproj) {
    DEFINES += IDE_LIBRARY_BASENAME=\"$$IDE_LIBRARY_BASENAME\"
} else {
    DEFINES += IDE_LIBRARY_BASENAME=\\\"$$IDE_LIBRARY_BASENAME\\\"
}

DEFINES += \
    QT_CREATOR \
    QT_NO_JAVA_STYLE_ITERATORS \
    QT_NO_CAST_TO_ASCII \
    QT_RESTRICTED_CAST_FROM_ASCII \
    QT_DISABLE_DEPRECATED_BEFORE=0x050900 \
    QT_USE_QSTRINGBUILDER

unix {
    CONFIG(debug, debug|release):OBJECTS_DIR = $${OUT_PWD}/.obj/debug-shared
    CONFIG(release, debug|release):OBJECTS_DIR = $${OUT_PWD}/.obj/release-shared

    CONFIG(debug, debug|release):MOC_DIR = $${OUT_PWD}/.moc/debug-shared
    CONFIG(release, debug|release):MOC_DIR = $${OUT_PWD}/.moc/release-shared

    RCC_DIR = $${OUT_PWD}/.rcc
    UI_DIR = $${OUT_PWD}/.uic
}

msvc {
    #Don't warn about sprintf, fopen etc being 'unsafe'
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CXXFLAGS_WARN_ON *= -w44996
    # Speed up startup time when debugging with cdb
    QMAKE_LFLAGS_DEBUG += /INCREMENTAL:NO
}

qt {
    contains(QT, core): QT += concurrent
    contains(QT, core): greaterThan(QT_MAJOR_VERSION, 5): QT += core5compat
    contains(QT, gui): QT += widgets
}

QBSFILE = $$replace(_PRO_FILE_, \\.pro$, .qbs)
exists($$QBSFILE):DISTFILES += $$QBSFILE
DISTFILES += $$_PRO_FILE_PWD_/CMakeLists.txt

!isEmpty(QTC_PLUGIN_DEPENDS) {
    LIBS *= -L$$IDE_PLUGIN_PATH  # plugin path from output directory
    LIBS *= -L$$LINK_PLUGIN_PATH  # when output path is different from Qt Creator build directory
}

# recursively resolve plugin deps
done_plugins =
for(ever) {
    isEmpty(QTC_PLUGIN_DEPENDS): \
        break()
    done_plugins += $$QTC_PLUGIN_DEPENDS
    for(dep, QTC_PLUGIN_DEPENDS) {
        dependencies_file =
        for(dir, QTC_PLUGIN_DIRS) {
            exists($$dir/$$dep/$${dep}_dependencies.pri) {
                dependencies_file = $$dir/$$dep/$${dep}_dependencies.pri
                break()
            }
        }
        isEmpty(dependencies_file): \
            error("Plugin dependency $$dep not found")
        include($$dependencies_file)
        LIBS += -l$$qtLibraryName($$QTC_PLUGIN_NAME)
    }
    QTC_PLUGIN_DEPENDS = $$unique(QTC_PLUGIN_DEPENDS)
    QTC_PLUGIN_DEPENDS -= $$unique(done_plugins)
}

# recursively resolve library deps
done_libs =
for(ever) {
    isEmpty(QTC_LIB_DEPENDS): \
        break()
    done_libs += $$QTC_LIB_DEPENDS
    for(dep, QTC_LIB_DEPENDS) {
        dependencies_file =
        for(dir, QTC_LIB_DIRS) {
            exists($$dir/$$dep/$${dep}_dependencies.pri) {
                dependencies_file = $$dir/$$dep/$${dep}_dependencies.pri
                break()
            }
        }
        isEmpty(dependencies_file): \
            error("Library dependency $$dep not found")
        include($$dependencies_file)
        LIBS += -l$$qtLibraryName($$QTC_LIB_NAME)
    }
    QTC_LIB_DEPENDS = $$unique(QTC_LIB_DEPENDS)
    QTC_LIB_DEPENDS -= $$unique(done_libs)
}
