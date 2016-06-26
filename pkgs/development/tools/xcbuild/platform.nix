{ stdenv, sdk, writeText, platformName, xcbuild }:

let

  Info = {
    CFBundleIdentifier = platformName;
    Type = "Platform";
  };

  Version = {
    ProjectName = "OSXPlatformSupport";
  };

  PackageTypes = [
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.mach-o-executable";
        Name = "Mach-O Executable";
        Description = "Mach-O executable";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
        };
        ProductReference = {
            FileType = "compiled.mach-o.executable";
            Name = "$(EXECUTABLE_NAME)";
            IsLaunchable = "YES";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.mach-o-objfile";
        Name = "Mach-O Object File";
        Description = "Mach-O Object File";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
        };
        ProductReference = {
            FileType = "compiled.mach-o.objfile";
            Name = "$(EXECUTABLE_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.mach-o-dylib";
        Name = "Mach-O Dynamic Library";
        Description = "Mach-O dynamic library";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
        };
        ProductReference = {
            FileType = "compiled.mach-o.dylib";
            Name = "$(EXECUTABLE_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.static-library";
        Name = "Mach-O Static Library";
        Description = "Mach-O static library";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "lib";
            EXECUTABLE_SUFFIX = ".a";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
        };
        ProductReference = {
            FileType = "archive.ar";
            Name = "$(EXECUTABLE_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.mach-o-bundle";
        Name = "Mach-O Loadable";
        Description = "Mach-O loadable";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = ".dylib";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
        };
        ProductReference = {
            FileType = "compiled.mach-o.bundle";
            Name = "$(EXECUTABLE_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper";
        Name = "Wrapper";
        Description = "Wrapper";
        DefaultBuildSettings = {
            WRAPPER_PREFIX = "";
            WRAPPER_SUFFIX = ".bundle";
            WRAPPER_NAME = "$(WRAPPER_PREFIX)$(PRODUCT_NAME)$(WRAPPER_SUFFIX)";
            CONTENTS_FOLDER_PATH = "$(WRAPPER_NAME)/Contents";
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/MacOS";
            EXECUTABLE_PATH = "$(EXECUTABLE_FOLDER_PATH)/$(EXECUTABLE_NAME)";
            INFOPLIST_PATH = "$(CONTENTS_FOLDER_PATH)/Info.plist";
            INFOSTRINGS_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)/InfoPlist.strings";
            PKGINFO_PATH = "$(CONTENTS_FOLDER_PATH)/PkgInfo";
            PBDEVELOPMENTPLIST_PATH = "$(CONTENTS_FOLDER_PATH)/pbdevelopment.plist";
            VERSIONPLIST_PATH = "$(CONTENTS_FOLDER_PATH)/version.plist";
            PUBLIC_HEADERS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Headers";
            PRIVATE_HEADERS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/PrivateHeaders";
            EXECUTABLES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Executables";                      FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Frameworks";
            SHARED_FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/SharedFrameworks";
            SHARED_SUPPORT_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/SharedSupport";
            UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Resources";
            LOCALIZED_RESOURCES_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/$(DEVELOPMENT_LANGUAGE).lproj";
            DOCUMENTATION_FOLDER_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)/Documentation";
            PLUGINS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/PlugIns";
            SCRIPTS_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Scripts";
            JAVA_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Java";
        };
        ProductReference = {
            FileType = "wrapper.cfbundle";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.shallow";
        BasedOn = "com.apple.package-type.wrapper";
        Name = "Wrapper (Shallow)";
        Description = "Shallow Wrapper";
        DefaultBuildSettings = {
            CONTENTS_FOLDER_PATH = "$(WRAPPER_NAME)";
            EXECUTABLE_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)";
            UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)";
            SHALLOW_BUNDLE = "YES";
        };
        ProductReference = {
            FileType = "wrapper.cfbundle";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.application";
        BasedOn = "com.apple.package-type.wrapper";
        Name = "Application Wrapper";
        Description = "Application Wrapper";
        DefaultBuildSettings = {
            GENERATE_PKGINFO_FILE = "YES";
        };
        ProductReference = {
            FileType = "wrapper.application";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "YES";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.application.shallow";
        BasedOn = "com.apple.package-type.wrapper.shallow";
        Name = "Application Wrapper (Shallow)";
        Description = "Shallow Application Wrapper";
        DefaultBuildSettings = {
            UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)";
            GENERATE_PKGINFO_FILE = "YES";
            SHALLOW_BUNDLE = "YES";
        };
        ProductReference = {
            FileType = "wrapper.application";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "YES";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.framework";
        Name = "Framework Wrapper";
        Description = "Framework wrapper";
        DefaultBuildSettings = {
            WRAPPER_PREFIX = "";
            WRAPPER_SUFFIX = ".framework";
            WRAPPER_NAME = "$(WRAPPER_PREFIX)$(PRODUCT_NAME)$(WRAPPER_SUFFIX)";
            VERSIONS_FOLDER_PATH = "$(WRAPPER_NAME)/Versions";
            CONTENTS_FOLDER_PATH = "$(VERSIONS_FOLDER_PATH)/$(FRAMEWORK_VERSION)";
            CURRENT_VERSION = "Current";
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
            EXECUTABLE_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)";
            EXECUTABLE_PATH = "$(EXECUTABLE_FOLDER_PATH)/$(EXECUTABLE_NAME)";
            INFOPLIST_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Info.plist";
            INFOPLISTSTRINGS_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)/InfoPlist.strings";
            PKGINFO_PATH = "$(WRAPPER_NAME)/PkgInfo";
            PBDEVELOPMENTPLIST_PATH = "$(CONTENTS_FOLDER_PATH)/pbdevelopment.plist";
            VERSIONPLIST_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/version.plist";
            PUBLIC_HEADERS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Headers";
            PRIVATE_HEADERS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/PrivateHeaders";
            EXECUTABLES_FOLDER_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)";                       FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Frameworks";
            SHARED_FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/SharedFrameworks";
            SHARED_SUPPORT_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)";
            UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Resources";
            LOCALIZED_RESOURCES_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/$(DEVELOPMENT_LANGUAGE).lproj";
            DOCUMENTATION_FOLDER_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)/Documentation";
            PLUGINS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/PlugIns";
            SCRIPTS_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Scripts";
            JAVA_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Java";
            CODESIGNING_FOLDER_PATH = "$(TARGET_BUILD_DIR)/$(CONTENTS_FOLDER_PATH)";
        };
        ProductReference = {
            FileType = "wrapper.framework";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.framework.static";
        Name = "Mach-O Static Framework";
        Description = "Mach-O static framework";
        BasedOn = "com.apple.package-type.wrapper.framework";
        DefaultBuildSettings = {
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        };
        ProductReference = {
            FileType = "wrapper.framework.static";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.wrapper.framework.shallow";
        Name = "Shallow Framework Wrapper";
        Description = "Shallow framework wrapper";
        BasedOn = "com.apple.package-type.wrapper.framework";
        DefaultBuildSettings = {
            CONTENTS_FOLDER_PATH = "$(WRAPPER_NAME)";
            VERSIONS_FOLDER_PATH = "$(WRAPPER_NAME)";
            UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)";
            SHALLOW_BUNDLE = "YES";
        };
        ProductReference = {
            FileType = "wrapper.framework";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
    {
        Type = "PackageType";
        Identifier = "com.apple.package-type.bundle.unit-test";
        BasedOn = "com.apple.package-type.wrapper";
        Name = "Unit Test Bundle";
        Description = "Unit Test Bundle";
        DefaultBuildSettings = {
            WRAPPER_SUFFIX = "xctest";
        };
        ProductReference = {
            FileType = "wrapper.cfbundle";
            Name = "$(WRAPPER_NAME)";
            IsLaunchable = "NO";
        };
    }
  ];

  ProductTypes = [
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.tool";
        Class = "PBXToolProductType";
        Name = "Command-line Tool";
        Description = "Standalone command-line tool";
        IconNamePrefix = "TargetExecutable";
        DefaultTargetName = "Command-line Tool";
        DefaultBuildProperties = {
            FULL_PRODUCT_NAME = "$(EXECUTABLE_NAME)";
            EXECUTABLE_PREFIX = "";
            EXECUTABLE_SUFFIX = "";
            REZ_EXECUTABLE = "YES";
            INSTALL_PATH = "/homeless-shelter";
            FRAMEWORK_FLAG_PREFIX = "-framework";
            LIBRARY_FLAG_PREFIX = "-l";
            LIBRARY_FLAG_NOSPACE = "YES";
            GCC_DYNAMIC_NO_PIC = "NO";
            GCC_SYMBOLS_PRIVATE_EXTERN = "YES";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "YES";
            STRIP_STYLE = "all";
            CODE_SIGNING_ALLOWED = "YES";
        };
        PackageTypes = [
            "com.apple.package-type.mach-o-executable"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.objfile";
        Class = "XCStandaloneExecutableProductType";
        Name = "Object File";
        Description = "Object File";
        IconNamePrefix = "TargetPlugin";
        DefaultTargetName = "Object File";
        DefaultBuildProperties = {
            FULL_PRODUCT_NAME = "$(EXECUTABLE_NAME)";
            MACH_O_TYPE = "mh_object";
            LINK_WITH_STANDARD_LIBRARIES = "NO";
            REZ_EXECUTABLE = "YES";
            EXECUTABLE_SUFFIX = ".$(EXECUTABLE_EXTENSION)";
            EXECUTABLE_EXTENSION = "o";
            PUBLIC_HEADERS_FOLDER_PATH = "/homeless-shelter";
            PRIVATE_HEADERS_FOLDER_PATH = "/homeless-shelter";
            INSTALL_PATH = "/homeless-shelter";
            FRAMEWORK_FLAG_PREFIX = "-framework";
            LIBRARY_FLAG_PREFIX = "-l";
            LIBRARY_FLAG_NOSPACE = "YES";
            SKIP_INSTALL = "YES";
            STRIP_STYLE = "debugging";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "YES";
            KEEP_PRIVATE_EXTERNS = "YES";
            DEAD_CODE_STRIPPING = "NO";
        };
        PackageTypes = [
            "com.apple.package-type.mach-o-objfile"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.library.dynamic";
        Class = "PBXDynamicLibraryProductType";
        Name = "Dynamic Library";
        Description = "Dynamic library";
        IconNamePrefix = "TargetLibrary";
        DefaultTargetName = "Dynamic Library";
        DefaultBuildProperties = {
            FULL_PRODUCT_NAME = "$(EXECUTABLE_NAME)";
            MACH_O_TYPE = "mh_dylib";
            REZ_EXECUTABLE = "YES";
            EXECUTABLE_SUFFIX = ".$(EXECUTABLE_EXTENSION)";
            EXECUTABLE_EXTENSION = "dylib";
            PUBLIC_HEADERS_FOLDER_PATH = "/homeless-shelter";
            PRIVATE_HEADERS_FOLDER_PATH = "/homeless-shelter";
            INSTALL_PATH = "/homeless-shelter";
            DYLIB_INSTALL_NAME_BASE = "$(INSTALL_PATH)";
            LD_DYLIB_INSTALL_NAME = "$(DYLIB_INSTALL_NAME_BASE:standardizepath)/$(EXECUTABLE_PATH)";
            DYLIB_COMPATIBILITY_VERSION = "1";
            DYLIB_CURRENT_VERSION = "1";
            FRAMEWORK_FLAG_PREFIX = "-framework";
            LIBRARY_FLAG_PREFIX = "-l";
            LIBRARY_FLAG_NOSPACE = "YES";
            STRIP_STYLE = "debugging";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "YES";
            CODE_SIGNING_ALLOWED = "YES";
        };
        PackageTypes = [
            "com.apple.package-type.mach-o-dylib"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.library.static";
        Class = "PBXStaticLibraryProductType";
        Name = "Static Library";
        Description = "Static library";
        IconNamePrefix = "TargetLibrary";
        DefaultTargetName = "Static Library";
        DefaultBuildProperties = {
            FULL_PRODUCT_NAME = "$(EXECUTABLE_NAME)";
            MACH_O_TYPE = "staticlib";
            REZ_EXECUTABLE = "YES";
            EXECUTABLE_PREFIX = "lib";
            EXECUTABLE_SUFFIX = ".$(EXECUTABLE_EXTENSION)";
            EXECUTABLE_EXTENSION = "a";
            PUBLIC_HEADERS_FOLDER_PATH = "/homeless-shelter";
            PRIVATE_HEADERS_FOLDER_PATH = "/homeless-shelter";
            INSTALL_PATH = "/homeless-shelter";
            FRAMEWORK_FLAG_PREFIX = "-framework";
            LIBRARY_FLAG_PREFIX = "-l";
            LIBRARY_FLAG_NOSPACE = "YES";
            STRIP_STYLE = "debugging";
            SEPARATE_STRIP = "YES";
        };
        AlwaysPerformSeparateStrip = "YES";
        PackageTypes = [
            "com.apple.package-type.static-library"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.bundle";
        Class = "PBXBundleProductType";
        Name = "Bundle";
        Description = "Generic bundle";
        IconNamePrefix = "TargetPlugin";
        DefaultTargetName = "Bundle";
        DefaultBuildProperties = {
            FULL_PRODUCT_NAME = "$(WRAPPER_NAME)";
            MACH_O_TYPE = "mh_bundle";
            WRAPPER_PREFIX = "";
            WRAPPER_SUFFIX = ".$(WRAPPER_EXTENSION)";
            WRAPPER_EXTENSION = "bundle";
            WRAPPER_NAME = "$(WRAPPER_PREFIX)$(PRODUCT_NAME)$(WRAPPER_SUFFIX)";
            FRAMEWORK_FLAG_PREFIX = "-framework";
            LIBRARY_FLAG_PREFIX = "-l";
            LIBRARY_FLAG_NOSPACE = "YES";
            STRIP_STYLE = "non-global";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "YES";
            CODE_SIGNING_ALLOWED = "YES";
        };
        PackageTypes = [
            "com.apple.package-type.wrapper"
            "com.apple.package-type.wrapper.shallow"
        ];
        IsWrapper = "YES";
        HasInfoPlist = "YES";
        HasInfoPlistStrings = "YES";
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.bundle.shallow";
        BasedOn = "com.apple.product-type.bundle";
        Class = "PBXBundleProductType";
        Name = "Bundle (Shallow)";
        Description = "Bundle (Shallow)";
        PackageTypes = [
            "com.apple.package-type.wrapper.shallow"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.application";
        BasedOn = "com.apple.product-type.bundle";
        Class = "PBXApplicationProductType";
        Name = "Application";
        Description = "Application";
        IconNamePrefix = "TargetApp";
        DefaultTargetName = "Application";
        DefaultBuildProperties = {
            MACH_O_TYPE = "mh_execute";
            GCC_DYNAMIC_NO_PIC = "NO";
            GCC_SYMBOLS_PRIVATE_EXTERN = "YES";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "YES";
            WRAPPER_SUFFIX = ".$(WRAPPER_EXTENSION)";
            WRAPPER_EXTENSION = "app";
            INSTALL_PATH = "$(LOCAL_APPS_DIR)";
            STRIP_STYLE = "all";
            CODE_SIGNING_ALLOWED = "YES";
        };
        PackageTypes = [
            "com.apple.package-type.wrapper.application"
        ];
        CanEmbedAddressSanitizerLibraries = "YES";
        RunpathSearchPathForEmbeddedFrameworks = "@executable_path/../Frameworks";
        ValidateEmbeddedBinaries = "YES";
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.application.shallow";
        BasedOn = "com.apple.product-type.application";
        Class = "PBXApplicationProductType";
        Name = "Application (Shallow Bundle)";
        Description = "Application (Shallow Bundle)";
        PackageTypes = [
            "com.apple.package-type.wrapper.application.shallow"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.framework";
        BasedOn = "com.apple.product-type.bundle";
        Class = "PBXFrameworkProductType";
        Name = "Framework";
        Description = "Framework";
        IconNamePrefix = "TargetFramework";
        DefaultTargetName = "Framework";
        DefaultBuildProperties = {
            MACH_O_TYPE = "mh_dylib";
            FRAMEWORK_VERSION = "A";
            WRAPPER_SUFFIX = ".$(WRAPPER_EXTENSION)";
            WRAPPER_EXTENSION = "framework";
            INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
            DYLIB_INSTALL_NAME_BASE = "$(INSTALL_PATH)";
            LD_DYLIB_INSTALL_NAME = "$(DYLIB_INSTALL_NAME_BASE:standardizepath)/$(EXECUTABLE_PATH)";
            STRIP_STYLE = "debugging";
            CODE_SIGNING_ALLOWED = "YES";
        };
        PackageTypes = [
            "com.apple.package-type.wrapper.framework"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.framework.shallow";
        BasedOn = "com.apple.product-type.framework";
        Class = "PBXFrameworkProductType";
        Name = "Framework (Shallow Bundle)";
        Description = "Framework (Shallow Bundle)";
        PackageTypes = [
            "com.apple.package-type.wrapper.framework.shallow"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.framework.static";
        BasedOn = "com.apple.product-type.framework";
        Class = "XCStaticFrameworkProductType";
        Name = "Static Framework";
        Description = "Static Framework";
        IconNamePrefix = "TargetFramework";
        DefaultTargetName = "Static Framework";
        DefaultBuildProperties = {
            MACH_O_TYPE = "staticlib";
            FRAMEWORK_VERSION = "A";
            WRAPPER_SUFFIX = ".$(WRAPPER_EXTENSION)";
            WRAPPER_EXTENSION = "framework";
            INSTALL_PATH = "$(LOCAL_LIBRARY_DIR)/Frameworks";
            DYLIB_INSTALL_NAME_BASE = "";
            LD_DYLIB_INSTALL_NAME = "";
            SEPARATE_STRIP = "YES";
            GCC_INLINES_ARE_PRIVATE_EXTERN = "NO";
            CODE_SIGNING_ALLOWED = "NO";
        };
        AlwaysPerformSeparateStrip = "YES";
        PackageTypes = [
            "com.apple.package-type.wrapper.framework.static"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.bundle.unit-test";
        BasedOn = "com.apple.product-type.bundle";
        Class = "PBXXCTestBundleProductType";
        Name = "Unit Test Bundle";
        Description = "Unit Test Bundle";
        DefaultBuildProperties = {
            WRAPPER_EXTENSION = "xctest";
            PRODUCT_SPECIFIC_LDFLAGS = "-framework XCTest";
            PRODUCT_TYPE_FRAMEWORK_SEARCH_PATHS = "$(TEST_FRAMEWORK_SEARCH_PATHS)";
            TEST_FRAMEWORK_SEARCH_PATHS = [
                "$(inherited)"
                "$(PLATFORM_DIR)/Developer/Library/Frameworks"
            ];
        };
        PackageTypes = [
            "com.apple.package-type.bundle.unit-test"
        ];
    }
    {
        Type = "ProductType";
        Identifier = "com.apple.product-type.bundle.ui-testing";
        BasedOn = "com.apple.product-type.bundle.unit-test";
        Class = "PBXXCTestBundleProductType";
        Name = "UI Testing Bundle";
        Description = "UI Testing Bundle";
        DefaultBuildProperties = {
            WRAPPER_EXTENSION = "xctest";
            USES_XCTRUNNER = "YES";
            PRODUCT_SPECIFIC_LDFLAGS = "-framework XCTest";
            PRODUCT_TYPE_FRAMEWORK_SEARCH_PATHS = "$(TEST_FRAMEWORK_SEARCH_PATHS)";
            TEST_FRAMEWORK_SEARCH_PATHS = [
                "$(inherited)"
                "$(PLATFORM_DIR)/Developer/Library/Frameworks"
            ];
        };
        PackageTypes = [
            "com.apple.package-type.bundle.unit-test"
        ];
    }
  ];

in

stdenv.mkDerivation {
  name = "nixpkgs.platform";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/
    cd $out/

    /usr/bin/plutil -convert xml1 -o Info.plist ${writeText "Info.plist" (builtins.toJSON Info)}
    /usr/bin/plutil -convert xml1 -o version.plist ${writeText "version.plist" (builtins.toJSON Version)}

    mkdir -p $out/Developer/Library/Xcode/Specifications/
    /usr/bin/plutil -convert xml1 -o $out/Developer/Library/Xcode/Specifications/ProductTypes.xcspec ${writeText "ProductTypes.xcspec" (builtins.toJSON ProductTypes)}
    /usr/bin/plutil -convert xml1 -o $out/Developer/Library/Xcode/Specifications/PackageTypes.xcspec ${writeText "PackageTypes.xcspec" (builtins.toJSON PackageTypes)}

    mkdir -p $out/Developer/SDKs/
    cd $out/Developer/SDKs/
    ln -s ${sdk}
  '';
}
