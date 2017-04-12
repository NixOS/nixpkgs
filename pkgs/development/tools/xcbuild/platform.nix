{ stdenv, sdk, writeText, platformName, xcbuild }:

let

  Info = {
    CFBundleIdentifier = platformName;
    Type = "Platform";
    Name = "macosx";
  };

  Version = {
    ProjectName = "OSXPlatformSupport";
  };

  # These files are all based off of Xcode spec fies found in
  # /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/Speciications/.

  # Based off of the MacOSX Architectures.xcpsec file. All i386 stuff
  # is removed because NixPkgs only supports darwin-x86_64.
  Architectures = [
    {
      Identifier = "Standard";
      Type = "Architecture";
      Name = "Standard Architectures (64-bit Intel)";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD";
    }
    {
      Identifier = "Universal";
      Type = "Architecture";
      Name = "Universal (64-bit Intel)";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD_32_64_BIT";
    }
    {
      Identifier = "Native";
      Type = "Architecture";
      Name = "Native Architecture of Build Machine";
      ArchitectureSetting = "NATIVE_ARCH_ACTUAL";
    }
    {
      Identifier = "Standard64bit";
      Type = "Architecture";
      Name = "64-bit Intel";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD_64_BIT";
    }
    {
      Identifier = "x86_64";
      Type = "Architecture";
      Name = "Intel 64-bit";
    }
    {
      Identifier = "Standard_Including_64_bit";
      Type = "Architecture";
      Name = "Standard Architectures (including 64-bit)";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD_INCLUDING_64_BIT";
    }
  ];

  # Based off of the MacOSX Package Types.xcpsec file. Only keep the
  # bare minimum needed.
  PackageTypes = [
    {
      Identifier = "com.apple.package-type.mach-o-executable";
      Type = "PackageType";
      Name = "Mach-O Executable";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.executable";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
    {
      Identifier = "com.apple.package-type.mach-o-objfile";
      Type = "PackageType";
      Name = "Mach-O Object File";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.objfile";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
    {
      Identifier = "com.apple.package-type.mach-o-dylib";
      Type = "PackageType";
      Name = "Mach-O Dynamic Library";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.dylib";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
    {
      Identifier = "com.apple.package-type.wrapper";
      Type = "PackageType";
      Name = "Wrapper";
      DefaultBuildSettings = {
        WRAPPER_SUFFIX = ".bundle";
        WRAPPER_NAME = "$(WRAPPER_PREFIX)$(PRODUCT_NAME)$(WRAPPER_SUFFIX)";
        CONTENTS_FOLDER_PATH = "$(WRAPPER_NAME)/Contents";
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
        EXECUTABLES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Executables";
        FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Frameworks";
        SHARED_FRAMEWORKS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/SharedFrameworks";
        SHARED_SUPPORT_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/SharedSupport";
        UNLOCALIZED_RESOURCES_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/Resources";
        LOCALIZED_RESOURCES_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/$(DEVELOPMENT_LANGUAGE).lproj";
        DOCUMENTATION_FOLDER_PATH = "$(LOCALIZED_RESOURCES_FOLDER_PATH)/Documentation";
        PLUGINS_FOLDER_PATH = "$(CONTENTS_FOLDER_PATH)/PlugIns";
        SCRIPTS_FOLDER_PATH = "$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Scripts";
      };
      ProductReference = {
        FileType = "wrapper.cfbundle";
        Name = "$(WRAPPER_NAME)";
        IsLaunchable = "NO";
      };
    }
    {
      Identifier = "com.apple.package-type.wrapper.application";
      Type = "PackageType";
      BasedOn = "com.apple.package-type.wrapper";
      Name = "Application Wrapper";
      DefaultBuildSettings = {
        GENERATE_PKGINFO_FILE = "YES";
      };
      ProductReference = {
        FileType = "wrapper.application";
        Name = "$(WRAPPER_NAME)";
        IsLaunchable = "YES";
      };
    }
  ];

  # Based off of the MacOSX Product Types.xcpsec file. All
  # bundles/wrapper are removed, because we prefer dynamic products in
  # NixPkgs.
  ProductTypes = [
    {
      Identifier = "com.apple.product-type.tool";
      Type = "ProductType";
      Name = "Command-line Tool";
      PackageTypes = [ "com.apple.package-type.mach-o-executable" ];
    }
    {
      Identifier = "com.apple.product-type.objfile";
      Type = "ProductType";
      Name = "Object File";
      PackageTypes = [ "com.apple.package-type.mach-o-objfile" ];
    }
    {
      Identifier = "com.apple.product-type.library.dynamic";
      Type = "ProductType";
      Name = "Dynamic Library";
      PackageTypes = [ "com.apple.package-type.mach-o-dylib" ];
    }
    {
      Type = "ProductType";
      Identifier = "com.apple.product-type.bundle";
      Name = "Bundle";
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
      };
      PackageTypes = [ "com.apple.package-type.wrapper" ];
      IsWrapper = "YES";
      HasInfoPlist = "YES";
      HasInfoPlistStrings = "YES";
    }
    {
      Identifier = "com.apple.product-type.application";
      Type = "ProductType";
      BasedOn = "com.apple.product-type.bundle";
      Name = "Application";
      DefaultBuildProperties = {
        MACH_O_TYPE = "mh_execute";
        WRAPPER_SUFFIX = ".$(WRAPPER_EXTENSION)";
        WRAPPER_EXTENSION = "app";
      };
      PackageTypes = [ "com.apple.package-type.wrapper.application" ];
    }
  ];

in

stdenv.mkDerivation {
  name = "nixpkgs.platform";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/
    cd $out/

    plutil -convert xml1 -o Info.plist ${writeText "Info.plist" (builtins.toJSON Info)}
    plutil -convert xml1 -o version.plist ${writeText "version.plist" (builtins.toJSON Version)}

    mkdir -p $out/Developer/Library/Xcode/Specifications/
    cd $out/Developer/Library/Xcode/Specifications/
    plutil -convert xml1 -o Architectures.xcspec ${writeText "Architectures.xcspec" (builtins.toJSON Architectures)}
    plutil -convert xml1 -o PackageTypes.xcspec ${writeText "PackageTypes.xcspec" (builtins.toJSON PackageTypes)}
    plutil -convert xml1 -o ProductTypes.xcspec ${writeText "ProductTypes.xcspec" (builtins.toJSON ProductTypes)}

    mkdir -p $out/Developer/SDKs/
    cd $out/Developer/SDKs/
    ln -s ${sdk}
  '';
}
