import qbs
import qbs.Environment
import qbs.FileInfo
import qbs.Utilities

Module {
    Depends { name: "cpp"; required: false }

    property string qtcreator_display_version: '9.0.1'
    property string ide_version_major: '9'
    property string ide_version_minor: '0'
    property string ide_version_release: '1'
    property string qtcreator_version: ide_version_major + '.' + ide_version_minor + '.'
                                       + ide_version_release

    property string ide_compat_version_major: '9'
    property string ide_compat_version_minor: '0'
    property string ide_compat_version_release: '0'
    property string qtcreator_compat_version: ide_compat_version_major + '.'
            + ide_compat_version_minor + '.' + ide_compat_version_release

    property string qtcreator_copyright_year: '2022'
    property string qtcreator_copyright_string: "(C) " + qtcreator_copyright_year + " The Qt Company Ltd"

    property string ide_display_name: 'Qt Creator'
    property string ide_id: 'qtcreator'
    property string ide_cased_id: 'QtCreator'
    property string ide_bundle_identifier: 'org.qt-project.qtcreator'

    property string libDirName: "lib"
    property string ide_app_path: qbs.targetOS.contains("macos") ? "" : "bin"
    property string ide_app_target: qbs.targetOS.contains("macos") ? ide_display_name : ide_id
    property string ide_library_path: {
        if (qbs.targetOS.contains("macos"))
            return ide_app_target + ".app/Contents/Frameworks"
        else if (qbs.targetOS.contains("windows"))
            return ide_app_path
        else
            return libDirName + "/qtcreator"
    }
    property string ide_plugin_path: {
        if (qbs.targetOS.contains("macos"))
            return ide_app_target + ".app/Contents/PlugIns"
        else if (qbs.targetOS.contains("windows"))
            return libDirName + "/qtcreator/plugins"
        else
            return ide_library_path + "/plugins"
    }
    property string ide_data_path: qbs.targetOS.contains("macos")
            ? ide_app_target + ".app/Contents/Resources"
            : "share/qtcreator"
    property string ide_libexec_path: qbs.targetOS.contains("macos")
            ? ide_data_path + "/libexec" : qbs.targetOS.contains("windows")
            ? ide_app_path
            : "libexec/qtcreator"
    property string ide_bin_path: qbs.targetOS.contains("macos")
            ? ide_app_target + ".app/Contents/MacOS"
            : ide_app_path
    property string ide_doc_path: qbs.targetOS.contains("macos")
            ? ide_data_path + "/doc"
            : "share/doc/qtcreator"
    property string ide_include_path: "include"
    property string ide_qbs_resources_path: "qbs-resources"
    property string ide_qbs_modules_path: ide_qbs_resources_path + "/modules"
    property string ide_qbs_imports_path: ide_qbs_resources_path + "/imports"
    property string ide_shared_sources_path: "src/shared"

    property string litehtmlInstallDir: Environment.getEnv("LITEHTML_INSTALL_DIR")

    property bool enableAddressSanitizer: false
    property bool enableUbSanitizer: false
    property bool enableThreadSanitizer: false

    property bool preferSystemSyntaxHighlighting: true

    property bool make_dev_package: false

    // Will be replaced when creating modules from products
    property string export_data_base: project.ide_source_tree + "/share/qtcreator"

    property bool testsEnabled: Environment.getEnv("TEST") || qbs.buildVariant === "debug"
    property stringList generalDefines: [
        "QT_CREATOR",
        'IDE_LIBRARY_BASENAME="' + libDirName + '"',
        'RELATIVE_PLUGIN_PATH="' + FileInfo.relativePath('/' + ide_bin_path,
                                                         '/' + ide_plugin_path) + '"',
        'RELATIVE_LIBEXEC_PATH="' + FileInfo.relativePath('/' + ide_bin_path,
                                                          '/' + ide_libexec_path) + '"',
        'RELATIVE_DATA_PATH="/RELATIVE_DATA_PATH/from/qtc.qbs"',
        'RELATIVE_DOC_PATH="' + FileInfo.relativePath('/' + ide_bin_path, '/' + ide_doc_path) + '"',
        "QT_NO_CAST_TO_ASCII",
        "QT_RESTRICTED_CAST_FROM_ASCII",
        "QT_DISABLE_DEPRECATED_BEFORE=0x050900",
        "QT_USE_QSTRINGBUILDER",
    ].concat(testsEnabled ? ["WITH_TESTS"] : [])
     .concat(qbs.toolchain.contains("msvc") ? ["_CRT_SECURE_NO_WARNINGS"] : [])
     .concat((qbs.toolchain.contains("msvc") && Utilities.versionCompare(qbs.version, "1.23.2") < 0)
        ? ["_ENABLE_EXTENDED_ALIGNED_STORAGE"] : [])

    Properties {
        condition: cpp.present && qbs.toolchain.contains("msvc") && product.Qt
                   && Utilities.versionCompare(Qt.core.version, "6.3") >= 0
                   && Utilities.versionCompare(cpp.compilerVersion, "19.10") >= 0
                   && Utilities.versionCompare(qbs.version, "1.23") < 0
        cpp.cxxFlags: "/permissive-"
    }
}
